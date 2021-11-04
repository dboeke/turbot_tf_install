import click
import boto3
import sys
import requests

@click.command()
@click.option('-p', '--product-type', type=click.Choice(['TE', 'TED', 'TEF']), help="Which product")
@click.option('-v', '--version', help="Downloads specific CF version when set: 'v10.11.66'")

def turbot_prep(product_type, version):
  """ Lists available versions or downloads cf templates for specific versions."""
  """
      Example Usage
      ---------------
      List available versions for all products:  python3 turbot_prep.py
      Download specific TE version:              python3 turbot_prep.py -p TE -v '10.11.66'
  """

  turbot_prod_catalog = {
    "TE": {
      "Name": "Turbot Enterprise",
      "ProdId": "",
      "Versions": {},
      "Latest": {}
    },
    "TED": {
      "Name": "Turbot Enterprise Database",
      "ProdId": "",
      "Versions": {},
      "Latest": {}
    },
    "TEF": {
      "Name": "Turbot Enterprise Foundation",
      "ProdId": "",
      "Versions": {},
      "Latest": {}
    } 
  }
  
  client = boto3.client('servicecatalog')
  s3client = boto3.client('s3')

  for avail_prod, prod_metadata in turbot_prod_catalog.items():
    response = client.search_products()

    found = False

    for product in response['ProductViewSummaries']:
      if not found and product['Name'] == prod_metadata['Name']:
        found = True
        turbot_prod_catalog[avail_prod]['ProdId'] = product['ProductId']
        print("Found {}. ProductId = {}, latest versions: ".format(product['Name'], product['ProductId']))
        response = client.describe_product(
          Id=prod_metadata['ProdId']
        )
        for artifact in response['ProvisioningArtifacts']:
          turbot_prod_catalog[avail_prod]['Versions'][artifact['Name']] = artifact['Id']
          turbot_prod_catalog[avail_prod]['Latest'][artifact['Name']] = artifact['CreatedTime']
        for ver in sorted(turbot_prod_catalog[avail_prod]['Latest'], key=turbot_prod_catalog[avail_prod]['Latest'].__getitem__, reverse=True)[:5]:
          print("    -  {}: {}".format(ver, turbot_prod_catalog[avail_prod]['Versions'][ver]))

    if not found:
      sys.exit("Error: " + prod_metadata['Name'] + " ("+ avail_prod + ") not found in service catalog!")

  if version:
    print()
    if product_type:
      if version in turbot_prod_catalog[product_type]['Versions']:
        response = client.describe_provisioning_artifact(
          ProvisioningArtifactId=turbot_prod_catalog[product_type]['Versions'][version],
          ProductId=turbot_prod_catalog[product_type]['ProdId'],
          Verbose=True
        )
        if response['Status'] == "AVAILABLE":
          if response['ProvisioningArtifactDetail']['Active']:
            if 'CloudFormationTemplate' in response['Info']:
              print("Downloading version...")
              with open("turbot_{}_{}.cf.yml".format(product_type, version), 'w') as f:
                f.write(response['Info']['CloudFormationTemplate']) 
              print("Done")
      else:
        sys.exit("Error! Version {} for Product {} was not found.".format(version, product_type))
    else:
      sys.exit("Error! product type must be chosen when specifying a version.")


if __name__ == "__main__":
  try:
    turbot_prep()
  except Exception as e:
    print(e)