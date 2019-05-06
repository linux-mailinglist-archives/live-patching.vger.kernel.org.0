Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5A814999
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2019 14:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfEFMcP (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 6 May 2019 08:32:15 -0400
Received: from mx2.suse.de ([195.135.220.15]:47980 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfEFMcO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 6 May 2019 08:32:14 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2F29AE69;
        Mon,  6 May 2019 12:32:13 +0000 (UTC)
Date:   Mon, 6 May 2019 14:32:13 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
Message-ID: <20190506123213.zpgs6byhbgs2cffb@pathway.suse.cz>
References: <20190503143024.28358-1-pmladek@suse.com>
 <20190503151730.GC24094@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503151730.GC24094@redhat.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2019-05-03 11:17:30, Joe Lawrence wrote:
> On Fri, May 03, 2019 at 04:30:22PM +0200, Petr Mladek wrote:
> > This is the original Mauro's patch and my extra fixup as a clean
> > patchset.
> > 
> > I want to be sure that other livepatching maintainers are fine
> > with the changes ;-)
> > 
> > 
> > Mauro Carvalho Chehab (1):
> >   docs: livepatch: convert docs to ReST and rename to *.rst
> > 
> > Petr Mladek (1):
> >   docs/livepatch: Unify style of livepatch documentation in the ReST
> >     format
> > 
> >  Documentation/ABI/testing/sysfs-kernel-livepatch   |   2 +-
> >  .../livepatch/{callbacks.txt => callbacks.rst}     |  45 +--
> >  ...mulative-patches.txt => cumulative-patches.rst} |  14 +-
> >  Documentation/livepatch/index.rst                  |  21 ++
> >  .../livepatch/{livepatch.txt => livepatch.rst}     |  62 ++--
> >  ...module-elf-format.txt => module-elf-format.rst} | 353 +++++++++++----------
> >  .../livepatch/{shadow-vars.txt => shadow-vars.rst} |  65 ++--
> >  tools/objtool/Documentation/stack-validation.txt   |   2 +-
> >  8 files changed, 307 insertions(+), 257 deletions(-)
> >  rename Documentation/livepatch/{callbacks.txt => callbacks.rst} (87%)
> >  rename Documentation/livepatch/{cumulative-patches.txt => cumulative-patches.rst} (89%)
> >  create mode 100644 Documentation/livepatch/index.rst
> >  rename Documentation/livepatch/{livepatch.txt => livepatch.rst} (93%)
> >  rename Documentation/livepatch/{module-elf-format.txt => module-elf-format.rst} (55%)
> >  rename Documentation/livepatch/{shadow-vars.txt => shadow-vars.rst} (87%)
> > 
> > -- 
> > 2.16.4
> > 
> 
> Hi Petr,
> 
> >From a quick look at the 'make htmldocs' output, these look good.

Thanks for the look.

> I did notice that callbacks.rst updated "commit ("desc")" formatting,
> but shadow-vars.rst did not.  If you want to defer that nitpick until a
> larger formatting linting, I'd be fine with that.

If this is the only problem than I would defer it ;-)

Best Regards,
Petr
