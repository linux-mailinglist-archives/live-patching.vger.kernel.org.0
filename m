Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95C5218659
	for <lists+live-patching@lfdr.de>; Thu,  9 May 2019 09:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbfEIHrg (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 9 May 2019 03:47:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:39172 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725774AbfEIHrg (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 9 May 2019 03:47:36 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00AD1AE82;
        Thu,  9 May 2019 07:47:34 +0000 (UTC)
Date:   Thu, 9 May 2019 09:47:34 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jonathan Corbet <corbet@lwn.net>
cc:     Petr Mladek <pmladek@suse.com>, Jiri Kosina <jikos@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        live-patching@vger.kernel.org
Subject: Re: [PATCH 0/2] livepatch/docs: Convert livepatch documentation to
 the ReST format
In-Reply-To: <20190507161258.0c8dd3c8@lwn.net>
Message-ID: <alpine.LSU.2.21.1905090947180.12541@pobox.suse.cz>
References: <20190503143024.28358-1-pmladek@suse.com> <20190507161258.0c8dd3c8@lwn.net>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, 7 May 2019, Jonathan Corbet wrote:

> On Fri,  3 May 2019 16:30:22 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
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
> 
> I've applied the set, thanks.  It would be good to get it linked into the
> main doctree, though.  Not quite sure where to put it; perhaps the
> core-api manual is as good as any for now?

Yes, I think so.

Thanks,
Miroslav
