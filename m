Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B3816ED67
	for <lists+live-patching@lfdr.de>; Tue, 25 Feb 2020 19:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgBYSB3 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Feb 2020 13:01:29 -0500
Received: from mx2.suse.de ([195.135.220.15]:46726 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgBYSB3 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Feb 2020 13:01:29 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 641A4AD48;
        Tue, 25 Feb 2020 18:01:26 +0000 (UTC)
Date:   Tue, 25 Feb 2020 19:01:25 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Joe Lawrence <joe.lawrence@redhat.com>
cc:     Petr Mladek <pmladek@suse.com>, Will Deacon <will@kernel.org>,
        linux-kernel@vger.kernel.org, kernel-team@android.com,
        akpm@linux-foundation.org,
        "K . Prasad" <prasad@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Quentin Perret <qperret@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/3] Unexport kallsyms_lookup_name() and
 kallsyms_on_each_symbol()
In-Reply-To: <943e7093-2862-53c6-b7f4-96c7d65789b9@redhat.com>
Message-ID: <alpine.LSU.2.21.2002251854550.1630@pobox.suse.cz>
References: <20200221114404.14641-1-will@kernel.org> <alpine.LSU.2.21.2002251104130.11531@pobox.suse.cz> <20200225121125.psvuz6e7coa77vxe@pathway.suse.cz> <943e7093-2862-53c6-b7f4-96c7d65789b9@redhat.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1678380546-697660208-1582653686=:1630"
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--1678380546-697660208-1582653686=:1630
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 25 Feb 2020, Joe Lawrence wrote:

> On 2/25/20 7:11 AM, Petr Mladek wrote:
> > On Tue 2020-02-25 11:05:39, Miroslav Benes wrote:
> >> CC live-patching ML, because this could affect many of its users...
> >>
> >> On Fri, 21 Feb 2020, Will Deacon wrote:
> >>
> >>> Hi folks,
> >>>
> >>> Despite having just a single modular in-tree user that I could spot,
> >>> kallsyms_lookup_name() is exported to modules and provides a mechanism
> >>> for out-of-tree modules to access and invoke arbitrary, non-exported
> >>> kernel symbols when kallsyms is enabled.
> > 
> > Just to explain how this affects livepatching users.
> > 
> > Livepatch is a module that inludes fixed copies of functions that
> > are buggy in the running kernel. These functions often
> > call functions or access variables that were defined static in
> > the original source code. There are two ways how this is currently
> > solved.
> > 
> > Some livepatch authors use kallsyms_lookup_name() to locate the
> > non-exported symbols in the running kernel and then use these
> > address in the fixed code.
> > 
> 
> FWIW, kallsyms was historically used by the out-of-tree kpatch support module
> to resolve external symbols as well as call set_memory_r{w,o}() API.  All of
> that support code has been merged upstream, so modern kpatch modules* no
> longer leverage kallsyms by default.

Good. Quick grep through the sources gave me a couple of hits, so I was 
not sure.
 
> * That said, there are still some users who still use the deprecated support
> module with newer kernels, but that is not officially supported by the
> project.
> 
> > Another possibility is to used special relocation sections,
> > see Documentation/livepatch/module-elf-format.rst
> > 
> > The problem with the special relocations sections is that the support
> > to generate them is not ready yet. The main piece would klp-convert
> > tool. Its development is pretty slow. The last version can be
> > found at
> > https://lkml.kernel.org/r/20190509143859.9050-1-joe.lawrence@redhat.com
> > 
> > I am not sure if this use case is enough to keep the symbols exported.
> > Anyway, there are currently some out-of-tree users.
> > 
> 
> Another (temporary?) klp-relocation issue is that binutils has limited support
> for them as currently implemented:
> 
>   https://sourceware.org/ml/binutils/2020-02/msg00317.html
> 
> For example, try running strip or objcopy on a .ko that includes them and you
> may find surprising results :(
> 
> 
> As far as the klp-convert patchset goes, I forget whether or not we tied its
> use case to source-based livepatch creation.  If kallsyms goes unexported,
> perhaps it finds more immediate users.
>
> However since klp-convert provides nearly the same functionality as kallsyms,
> i.e. both can be used to circumvent symbol export licensing -- one could make
> similar arguments against its inclusion.

In a way yes, but as Masami described elsewhere in the thread there are 
more convenient ways to circumvent it even now. Not as convenient as 
kallsyms, of course. 
 
> If there is renewed (or greater, to be more accurate) interest in the
> klp-convert patchset, we can dust it off and see what's left.  AFAIK it was
> blocked on arch-specific klp-relocations and whether per-object​ livepatch
> modules would remove that requirement.

Yes, I think it is on standby now. I thought about it while walking 
through Petr's module split patch set and it seemed to me that klp-convert 
could be made much much simpler on top of that. So we should start there.

Anyway, as far as Will's patch set is concerned, there is no real obstacle 
on our side, is there?

Alexei mentioned ksplice from git history, but no one cares about ksplice 
in upstream now, I would say.

Thanks
Miroslav
--1678380546-697660208-1582653686=:1630--
