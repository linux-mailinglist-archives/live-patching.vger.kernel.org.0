Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B11368D7
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2019 02:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726543AbfFFArw (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jun 2019 20:47:52 -0400
Received: from mga17.intel.com ([192.55.52.151]:10260 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726541AbfFFArw (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jun 2019 20:47:52 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 17:47:52 -0700
X-ExtLoop1: 1
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.13.128])
  by fmsmga006.fm.intel.com with ESMTP; 05 Jun 2019 17:47:50 -0700
Date:   Thu, 6 Jun 2019 08:49:43 +0800
From:   Philip Li <philip.li@intel.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, lkp@01.org, pmladek@suse.com,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, jpoimboe@redhat.com
Subject: Re: [LKP] livepatching selftests failure on current master branch
Message-ID: <20190606004943.GA30795@intel.com>
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
 <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 05, 2019 at 10:51:53AM -0400, Joe Lawrence wrote:
> On 6/5/19 10:31 AM, Philip Li wrote:
> >On Wed, Jun 05, 2019 at 09:48:02AM -0400, Joe Lawrence wrote:
> >>On 5/17/19 10:17 AM, Miroslav Benes wrote:
> >>>Hi,
> >>>
> >>>I noticed that livepatching selftests fail on our master branch
> >>>(https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).
> >>>
> >>>...
> >>
> >>[ adding lkp@01.org to this email ]
> >>
> >>lkp folks, I was wondering if the kernel selftests were included as
> >>part of the test-bot and if so, do we need to do anything specific
> >yes, kernel selftest is part of regular execution, which includes the livepatching
> > test. Also the livepatching.git is under our testing...
> 
> Hi Philip,
> 
> Good to hear.  My github tree and Josh's kernel.org tree are
> included as (perhaps other livepatching dev trees as well), so the
> more coverage the better :)
> 
> >                                                  ... But we may not successfully
> >bisect all failures.
> 
> That's okay, though I guess I'm not clear why there wasn't an email
> reporting that the livepatching selftests failed after
> livepatching.git was recently updated to include tglx's stack trace
> fixes.
> 
> Do the tests only run for unique commits (ie, will it skip when
> livepatching.git updates/merges latest linux tree ??)
it will not skip, though we are not testing commit by commit. If the issue
is found, and bisect to the bad commit, we will report to author of that
commit for information.

> 
> Thanks,
> 
> -- Joe
