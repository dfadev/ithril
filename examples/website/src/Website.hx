import ithril.*;
import ithril.M.*;
using Reflect;
// Website
class Website implements IthrilView {
	static public function view(href)
		return function(vnode) @m[ (Base(vnode == null ? { } : vnode.attrs)(State.page(href))) ];
}

// Top level page wrapper wraps all pages
class Base extends Component {
#if browser
	override public function oncreate(vnode) setup(vnode);
	override public function onupdate(vnode) setup(vnode);
	function setup(vnode) {
		js.Browser.document.title = vnode.attrs.title;
		var favicon = js.Browser.document.head.querySelector('link[rel=${vnode.attrs.favicon.rel}]');
		favicon.setAttribute('href', vnode.attrs.favicon.href);
		favicon.setAttribute('type', vnode.attrs.favicon.type);
	}
#end

	override public function view(vnode:Vnode) @m[
#if !browser
		(!doctype)
		(html(lang='en'))

		(head)
			(vnode.attrs.meta => data)
				(meta(data))
			(title > vnode.attrs.title)
			(link(type=vnode.attrs.favicon.type, rel=vnode.attrs.favicon.rel, href=vnode.attrs.favicon.href))
			(vnode.attrs.css => css)
				(style > @trust css)
		(body)
#end
			(Navigation(id='navigation')(vnode.attrs))
			[m(Type.resolveClass(vnode.attrs.component), vnode.attrs)]
			(Footer(id='footer'))
#if !browser
			(vnode.attrs.javascript => javascript)
				(script(type='text/javascript') > @trust javascript)
#end
	];
}

// HomePage component
class HomePage extends Component {
	override public function view(vnode:Vnode) @m[
		(Content(header=vnode.attrs.homeHeader, text=vnode.attrs.homeText))
		(ContentPage(vnode.attrs))
	];
}

// ContentPage component
class ContentPage extends Component {
	override public function view(vnode:Vnode) @m[
		(vnode.attrs.content => content)
			(Content(header=content.header, text=content.text))
	];
}

// Navigation component
class Navigation extends Component {
	function active(test) return test ? "active" : "";

	override public function view(vnode:Vnode) @m[
		(nav(id=vnode.attrs.id, style=vnode.attrs.style))
			(a+brand(oncreate=routeLink, href=vnode.attrs.brandPage))
				[vnode.attrs.brand]
			(ul)
				(vnode.attrs.pages.fields() => href)
					[{
						var page = vnode.attrs.pages.field(href);
						if (page.nav != null)
							@m[
								(li(className=active(href == vnode.attrs.href)))
									(a(oncreate=routeLink, href=href, className=active(href == vnode.attrs.href)) > page.nav)
							]
						else
							@m[ ];
					}]
	];
}

// Footer component
class Footer extends Component {
	override public function view(vnode) @m[
		(div(id=vnode.attrs.id, style=vnode.attrs.style))
			(hr)
	];
}

// Page component
class Content extends Component {
	override public function view(vnode:Vnode) @m[
		(div.content(id=vnode.attrs.id, style=vnode.attrs.style))
			(div)
				(h2 > vnode.attrs.header)
			(div > vnode.attrs.text)
	];
}
