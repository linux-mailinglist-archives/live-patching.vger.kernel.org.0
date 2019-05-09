Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C950318622
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 09:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfEIHYz (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 03:24:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:35930 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726549AbfEIHYz (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 03:24:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EED45AC24;
        Thu,  9 May 2019 07:24:53 +0000 (UTC)
Date:   Thu, 9 May 2019 09:24:53 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] livepatch: Remove duplicate warning about missing
 reliable stacktrace support
In-Reply-To: <20190507212425.7gfqx5e3yc4fbdfy@treble>
Message-ID: <alpine.LSU.2.21.1905090921460.12541@pobox.suse.cz>
References: <20190430091049.30413-1-pmladek@suse.com> <20190430091049.30413-2-pmladek@suse.com> <20190507004032.2fgddlsycyypqdsn@treble> <20190507014332.l5pmvjyfropaiui2@treble> <20190507112950.wejw6nmfwzmm3vaf@pathway.suse.cz> <20190507120350.gpazr6xivzwvd3az@treble>
 <20190507142847.pre7tvm4oysimfww@pathway.suse.cz> <20190507212425.7gfqx5e3yc4fbdfy@treble>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org


> > > But I think Miroslav's suggestion to revert 1d98a69e5cef would be even
> > > better.
> > 
> > AFAIK, Miroslav wanted to point out that your opinion was inconsistent.
> 
> How is my opinion inconsistent?
> 
> Is there something wrong with the original approach, which was reverted
> with
> 
>   1d98a69e5cef ("livepatch: Remove reliable stacktrace check in klp_try_switch_task()")
> 
> ?
> 
> As I mentioned, that has some advantages:
> 
> - The generated code is simpler/faster because it uses a build-time
>   check.
> 
> - The code is more readable IMO.  Especially if the check is done higher
>   up the call stack by reverting 1d98a69e5cef.  That way the arch
>   support short-circuiting is done in the logical place, before doing
>   any more unnecessary work.  It's faster, but also, more importantly,
>   it's less surprising.

Correct. I forgot we removed return from klp_enable_patch() if 
klp_have_reliable_stack() errors out and we only warn now. So reverting 
1d98a69e5cef definitely makes sense.

My...

"We removed it in 1d98a69e5cef ("livepatch: Remove reliable stacktrace 
check in klp_try_switch_task()") and I do think it does not belong here. 
We can check for the facility right at the beginning in klp_enable_patch() 
and it is not necessary to do it every time klp_check_stack() is called." 

...from the other email is rubbish then.

Miroslav
