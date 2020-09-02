Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A6125AF8B
	for <lists+live-patching@lfdr.de>; Wed,  2 Sep 2020 17:41:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgIBPkv (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 2 Sep 2020 11:40:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:39248 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726802AbgIBNpf (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 2 Sep 2020 09:45:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9147AB60B;
        Wed,  2 Sep 2020 13:45:34 +0000 (UTC)
Date:   Wed, 2 Sep 2020 15:45:33 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        nstange@suse.de
Subject: Re: [PATCH 1/2] docs/livepatch: Add new compiler considerations
 doc
In-Reply-To: <20200721161407.26806-2-joe.lawrence@redhat.com>
Message-ID: <alpine.LSU.2.21.2009021452560.23200@pobox.suse.cz>
References: <20200721161407.26806-1-joe.lawrence@redhat.com> <20200721161407.26806-2-joe.lawrence@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

first, I'm sorry for the late reply. Thanks, Josh, for the reminder.

CCing Nicolai. Nicolai, could you take a look at the proposed 
documentation too, please? You have more up-to-date experience.

On Tue, 21 Jul 2020, Joe Lawrence wrote:

> +Examples
> +========
> +
> +Interprocedural optimization (IPA)
> +----------------------------------
> +
> +Function inlining is probably the most common compiler optimization that
> +affects livepatching.  In a simple example, inlining transforms the original
> +code::
> +
> +	foo() { ... [ foo implementation ] ... }
> +
> +	bar() { ...  foo() ...  }
> +
> +to::
> +
> +	bar() { ...  [ foo implementation ] ...  }
> +
> +Inlining is comparable to macro expansion, however the compiler may inline
> +cases which it determines worthwhile (while preserving original call/return
> +semantics in others) or even partially inline pieces of functions (see cold
> +functions in GCC function suffixes section below).
> +
> +To safely livepatch ``foo()`` from the previous example, all of its callers
> +need to be taken into consideration.  For those callers that the compiler had
> +inlined ``foo()``, a livepatch should include a new version of the calling
> +function such that it:
> +
> +  1. Calls a new, patched version of the inlined function, or
> +  2. Provides an updated version of the caller that contains its own inlined
> +     and updated version of the inlined function

I'm afraid the above could cause a confusion...

"1. Calls a new, patched version of the inlined function, or". The 
function is not inlined in this case. Would it be more understandable to 
use function names?

1. Calls a new, patched version of function foo(), or
2. Provides an updated version of bar() that contains its own inlined and 
   updated version of foo() (as seen in the example above).

Not to say that it is again a call of the compiler to decide that, so one 
usually prepares an updated version of foo() and updated version of bar() 
calling to it. Updated foo() has to be there for non-inlined cases anyway.

> +
> +Other interesting IPA examples include:
> +
> +- *IPA-SRA*: removal of unused parameters, replace parameters passed by
> +  referenced by parameters passed by value.  This optimization basically

s/referenced/reference/

> +  violates ABI.
> +
> +  .. note::
> +     GCC changes the name of function.  See GCC function suffixes
> +     section below.
> +
> +- *IPA-CP*: find values passed to functions are constants and then optimizes
> +  accordingly Several clones of a function are possible if a set is limited.

"...accordingly. Several..."

[...]

> +  	void cdev_put(struct cdev *p)
> +  	{
> +  		if (p) {
> +  			struct module *owner = p->owner;
> +  			kobject_put(&p->kobj);
> +  			module_put(owner);
> +  		}
> +  	}

git am complained here about whitespace damage.

[...]

> +kgraft-analysis-tool
> +--------------------
> +
> +With the -fdump-ipa-clones flag, GCC will dump IPA clones that were created
> +by all inter-procedural optimizations in ``<source>.000i.ipa-clones`` files.
> +
> +kgraft-analysis-tool pretty-prints those IPA cloning decisions.  The full
> +list of affected functions provides additional updates that the source-based
> +livepatch author may need to consider.  For example, for the function
> +``scatterwalk_unmap()``:
> +
> +::
> +
> +  $ ./kgraft-ipa-analysis.py --symbol=scatterwalk_unmap aesni-intel_glue.i.000i.ipa-clones
> +  Function: scatterwalk_unmap/2930 (include/crypto/scatterwalk.h:81:60)
> +    isra: scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
> +      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> +      inlining to: helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> +      inlining to: helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)
> +
> +    Affected functions: 3
> +      scatterwalk_unmap.isra.2/3142 (include/crypto/scatterwalk.h:81:60)
> +      helper_rfc4106_decrypt/3007 (arch/x86/crypto/aesni-intel_glue.c:1016:12)
> +      helper_rfc4106_encrypt/3006 (arch/x86/crypto/aesni-intel_glue.c:939:12)

The example for the github is not up-to-date. The tool now expects 
file_list with *.ipa-clones files and the output is a bit different for 
the recent kernel.

$ echo arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones | kgraft-ipa-analysis.py --symbol=scatterwalk_unmap /dev/stdin
Parsing file (1/1): arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones
Function: scatterwalk_unmap/3935 (./include/crypto/scatterwalk.h:59:20) [REMOVED] [object file: arch/x86/crypto/aesni-intel_glue.c.000i.ipa-clones]
  isra: scatterwalk_unmap.isra.8/4117 (./include/crypto/scatterwalk.h:59:20) [REMOVED]
    inlining to: gcmaes_crypt_by_sg/4019 (arch/x86/crypto/aesni-intel_glue.c:682:12) [REMOVED] [edges: 4]
      constprop: gcmaes_crypt_by_sg.constprop.13/4182 (arch/x86/crypto/aesni-intel_glue.c:682:12)

  Affected functions: 3
    scatterwalk_unmap.isra.8/4117 (./include/crypto/scatterwalk.h:59:20) [REMOVED]
    gcmaes_crypt_by_sg/4019 (arch/x86/crypto/aesni-intel_glue.c:682:12) [REMOVED]
    gcmaes_crypt_by_sg.constprop.13/4182 (arch/x86/crypto/aesni-intel_glue.c:682:12)



The rest looks great. Thanks a lot, Joe, for putting it together.

Miroslav
