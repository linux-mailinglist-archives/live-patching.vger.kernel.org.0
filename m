Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8959845512
	for <lists+live-patching@lfdr.de>; Fri, 14 Jun 2019 08:53:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfFNGxy (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jun 2019 02:53:54 -0400
Received: from mga14.intel.com ([192.55.52.115]:19167 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbfFNGxy (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jun 2019 02:53:54 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jun 2019 23:53:53 -0700
X-ExtLoop1: 1
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.13.128])
  by orsmga004.jf.intel.com with ESMTP; 13 Jun 2019 23:53:51 -0700
Date:   Fri, 14 Jun 2019 14:55:57 +0800
From:   Philip Li <philip.li@intel.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, lkp@01.org, jikos@kernel.org,
        Miroslav Benes <mbenes@suse.cz>, tglx@linutronix.de,
        jpoimboe@redhat.com
Subject: Re: [LKP] livepatching selftests failure on current master branch
Message-ID: <20190614065557.GA12282@intel.com>
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
 <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
 <20190606004943.GA30795@intel.com>
 <20190611074257.kogayuriz5aovv4b@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611074257.kogayuriz5aovv4b@pathway.suse.cz>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, Jun 11, 2019 at 09:42:57AM +0200, Petr Mladek wrote:
> On Thu 2019-06-06 08:49:43, Philip Li wrote:
> > On Wed, Jun 05, 2019 at 10:51:53AM -0400, Joe Lawrence wrote:
> > > On 6/5/19 10:31 AM, Philip Li wrote:
> > > >On Wed, Jun 05, 2019 at 09:48:02AM -0400, Joe Lawrence wrote:
> > > That's okay, though I guess I'm not clear why there wasn't an email
> > > reporting that the livepatching selftests failed after
> > > livepatching.git was recently updated to include tglx's stack trace
> > > fixes.
> > > 
> > > Do the tests only run for unique commits (ie, will it skip when
> > > livepatching.git updates/merges latest linux tree ??)
> > it will not skip, though we are not testing commit by commit. If the issue
> > is found, and bisect to the bad commit, we will report to author of that
> > commit for information.
> 
> Bisecting might take a lot of time or even fail. But each selftest
> should get associated with a kernel subsystem. It would be helpful
> to always inform the subsystem maintainers. Or at least the author
> of the selftest that failed.
thanks for the suggestion, we haven't done this yet that we uses merging
approach (merge different repos together to test) to speed up the testing,
so we need to bisect to make sure the issue is reproducible and not related
to merge. But anyway, we will consider this for future todo.

> 
> Best Regards,
> Petr
