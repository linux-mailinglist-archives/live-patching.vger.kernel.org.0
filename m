Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C3C958F3
	for <lists+live-patching@lfdr.de>; Tue, 20 Aug 2019 09:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729337AbfHTHyP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 20 Aug 2019 03:54:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:44672 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbfHTHyP (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 20 Aug 2019 03:54:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id AE5E9AE1B;
        Tue, 20 Aug 2019 07:54:13 +0000 (UTC)
Date:   Tue, 20 Aug 2019 09:54:05 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        live-patching@vger.kernel.org,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH v4 06/10] modpost: Add modinfo flag to livepatch
 modules
In-Reply-To: <9127bdf6-1daf-0387-88fb-6f1118dd6804@redhat.com>
Message-ID: <alpine.LSU.2.21.1908200948260.9536@pobox.suse.cz>
References: <20190509143859.9050-1-joe.lawrence@redhat.com> <20190509143859.9050-7-joe.lawrence@redhat.com> <CAK7LNAQuS-YcXecfJ21BGzc0CimzWxQcYST5-1xRgnCQGtcL4A@mail.gmail.com> <20190812155626.GA19845@redhat.com> <CAK7LNATRLTBqA9c=b+Y38T-zWc9o5JMq18r9auA=enPC=p10pA@mail.gmail.com>
 <alpine.LSU.2.21.1908161016430.2020@pobox.suse.cz> <6c7e4d19-b993-1c14-d6cf-6aa1ee891361@redhat.com> <163ad1fb-ccbf-0a3e-d795-2bb748a0e88f@redhat.com> <CAK7LNAR-1qXUhZ=cKUK2WEg5WeinXgFf1B2rq-=Oke4CUucp_g@mail.gmail.com>
 <9127bdf6-1daf-0387-88fb-6f1118dd6804@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > How is this feature supposed to work for external modules?
> > 
> > klp-convert receives:
> > "symbols from vmlinux" + "symbols from no-klp in-tree modules"
> > + "symbols from no-klp external modules" ??
> > 
> 
> I don't think that this use-case has been previously thought out (Miroslav,
> correct me if I'm wrong here.)
> 
> I did just run an external build of a copy of
> samples/livepatch/livepatch-annotated-sample.c:
> 
>  - modules.livepatch is generated in external dir
>  - klp-convert is invoked for the livepatch module
>  - the external livepatch module successfully loads
> 
> But that was only testing external livepatch modules.
> 
> I don't know if we need/want to support general external modules supplementing
> Symbols.list, at least for the initial klp-convert commit.  I suppose external
> livepatch modules would then need to specify additional Symbols.list(s) files
> somehow as well.

I think we discussed it briefly and decided to postpone it for later 
improvements. External modules are not so important in my opinion.
 
> > 
> > BTW, 'Symbols.list' sounds like a file to list out symbols
> > for generic purposes, but in fact, the
> > file format is very specific for the klp-convert tool.
> > Perhaps, is it better to rename it so it infers
> > this is for livepatching? What do you think?
> > 
> 
> I don't know if the "Symbols.list" name and leading uppercase was based on any
> convention, but something like symbols.klp would be fine with me.

symbols.klp looks ok

Miroslav
