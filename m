Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AEB325BEC3
	for <lists+live-patching@lfdr.de>; Thu,  3 Sep 2020 12:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726268AbgICKC1 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 3 Sep 2020 06:02:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:40846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbgICKC1 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 3 Sep 2020 06:02:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8BE39AB9F;
        Thu,  3 Sep 2020 10:02:26 +0000 (UTC)
Date:   Thu, 3 Sep 2020 12:02:24 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] Revert "kbuild: use -flive-patching when
 CONFIG_LIVEPATCH is enabled"
Message-ID: <20200903100224.GA20558@alley>
References: <696262e997359666afa053fe7d1a9fb2bb373964.1595010490.git.jpoimboe@redhat.com>
 <alpine.LSU.2.21.2007211316410.31851@pobox.suse.cz>
 <20200806092426.GL24529@alley>
 <20200901172451.uckohkruradfhd6g@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901172451.uckohkruradfhd6g@treble>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2020-09-01 12:24:51, Josh Poimboeuf wrote:
> On Thu, Aug 06, 2020 at 11:24:26AM +0200, Petr Mladek wrote:
> > On Tue 2020-07-21 13:17:00, Miroslav Benes wrote:
> > > On Fri, 17 Jul 2020, Josh Poimboeuf wrote:
> > > 
> > > > Use of the new -flive-patching flag was introduced with the following
> > > > commit:
> > > > 
> > > >   43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> > > > 
> > > > This reverts commit 43bd3a95c98e1a86b8b55d97f745c224ecff02b9.
> > > > 
> > > > Fixes: 43bd3a95c98e ("kbuild: use -flive-patching when CONFIG_LIVEPATCH is enabled")
> > > > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > > > Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> > > 
> > > Acked-by: Miroslav Benes <mbenes@suse.cz>
> > 
> > Acked-by: Petr Mladek <pmladek@suse.com>
> > 
> > Hmm, the patch has not been pushed into livepatching.git and is not
> > available in the pull request for 5.9.
> > 
> > Is it OK to leave it for 5.10?
> > Or would you prefer to get it into 5.9 even on this stage?
> > 
> > I personally do not mind. It depends how urgent it is for others.
> 
> Sorry for leaving this question hanging.  Let's go with 5.10 ;-)

The patch is committed in livepatch.git, branch
for-5.10/flive-patching.

Best Regards,
Petr
