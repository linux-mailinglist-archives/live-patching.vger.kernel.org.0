Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1509B3C550
	for <lists+live-patching@lfdr.de>; Tue, 11 Jun 2019 09:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403997AbfFKHm7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 11 Jun 2019 03:42:59 -0400
Received: from mx2.suse.de ([195.135.220.15]:47442 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2403920AbfFKHm7 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Tue, 11 Jun 2019 03:42:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 05440AB99;
        Tue, 11 Jun 2019 07:42:57 +0000 (UTC)
Date:   Tue, 11 Jun 2019 09:42:57 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Philip Li <philip.li@intel.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, lkp@01.org, jikos@kernel.org,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        jpoimboe@redhat.com
Subject: Re: [LKP] livepatching selftests failure on current master branch
Message-ID: <20190611074257.kogayuriz5aovv4b@pathway.suse.cz>
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
 <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
 <20190606004943.GA30795@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606004943.GA30795@intel.com>
User-Agent: NeoMutt/20170912 (1.9.0)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2019-06-06 08:49:43, Philip Li wrote:
> On Wed, Jun 05, 2019 at 10:51:53AM -0400, Joe Lawrence wrote:
> > On 6/5/19 10:31 AM, Philip Li wrote:
> > >On Wed, Jun 05, 2019 at 09:48:02AM -0400, Joe Lawrence wrote:
> > That's okay, though I guess I'm not clear why there wasn't an email
> > reporting that the livepatching selftests failed after
> > livepatching.git was recently updated to include tglx's stack trace
> > fixes.
> > 
> > Do the tests only run for unique commits (ie, will it skip when
> > livepatching.git updates/merges latest linux tree ??)
> it will not skip, though we are not testing commit by commit. If the issue
> is found, and bisect to the bad commit, we will report to author of that
> commit for information.

Bisecting might take a lot of time or even fail. But each selftest
should get associated with a kernel subsystem. It would be helpful
to always inform the subsystem maintainers. Or at least the author
of the selftest that failed.

Best Regards,
Petr
