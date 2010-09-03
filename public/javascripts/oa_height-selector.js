// Enables to select with :height parameter

jQuery.extend(jQuery.expr[':'],{
    height: function(a,i,m) {
        if(!m[3]||!(/^(<|>)\d+$/).test(m[3])) {return false;}
        return m[3].substr(0,1) === '>' ? 
                 jQuery(a).height() > m[3].substr(1) : jQuery(a).height() < m[3].substr(1);
    }
});