/* Copyright© 2017 Merck Sharp & Dohme Corp. a subsidiary of Merck & Co., Inc., Kenilworth, NJ, USA.  Licensed under the Apache License, Version 2.0 (the "License");    you may not use this file except in compliance with the License.    You may obtain a copy of the License at       http://www.apache.org/licenses/LICENSE-2.0     Unless required by applicable law or agreed to in writing, software    distributed under the License is distributed on an "AS IS" BASIS,    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.    See the License for the specific language governing permissions and    limitations under the License.  */
var ExternalLinks = new function() {
  //this.setExternalLinks = function() {
  //  var notice = "You will be leaving our Company Intranet and entering a website hosted by another party. You will no longer be subject to, \
  //                or under the protection of, the privacy and security policies of our Company’s website. While we are providing the link to this website, \
  //                we recommend you read the Privacy and Security Notices on the site you are entering, as these may be different from our Company.";
  //  $('i.glyphicon-new-window').parent().remove();

  //  $('a[href]:not([href^="/"], [href^="mailto:"], [href^=\\#], [href^="javascript:"]):not(.nojqueryanchor):not(:has(img))').filter(function(a) {
  //   return !/^(http[s]?:\/\/)?[a-z0-9-.]*\.(Linea|msd)\.com[?\/]?/.test($(this).attr('href'));
  //}).after('<a data-toggle="tooltip" data-placement="bottom" title="'+notice+'" href="#"><i class="glyphicon glyphicon-new-window external-link-icon" aria-hidden="true"></i></a>');
  //}
}

$(function() {
  ExternalLinks.setExternalLinks();
  //$('[data-toggle="tooltip"]').tooltip();
  $('body').tooltip({
    selector: '[data-toggle="tooltip"]'
  });
});
