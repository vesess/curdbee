# CurdBee

Ruby wrapper for the CurdBee API. Through this library you can peform actions on following resources:

* Invoices
* Estimates
* Recurring Profiles
* Clients
* Items
* Payments

## Installation

sudo gem install curdbee

## Configuration 

Before your code communicate with the CurdBee API, do the following:

    require 'curdbee'

    # set the API key and subdomain for your account.
    CurdBee::Config.api_key = "Your API Key"
    CurdBee::Config.subdomain = "Your Subdomain"

To find your API Token, please login to your CurdBee account and visit Settings > Account Information
    
## Examples

Check `examples/` directory for example usage.

## How to Contribute? 

You will need to have bundler gem installed in your system.
 
    $ sudo gem install bundler
    $ git clone git://github.com/vesess/curdbee.git
    $ cd curdbee
    $ bundle install
    
### Copyright

See LICENSE for details.
