Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B335F41
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2019 16:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfFEO3k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jun 2019 10:29:40 -0400
Received: from mga18.intel.com ([134.134.136.126]:44707 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbfFEO3j (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jun 2019 10:29:39 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 07:29:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,550,1549958400"; 
   d="scan'208";a="181947237"
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.13.128])
  by fmsmga002.fm.intel.com with ESMTP; 05 Jun 2019 07:29:25 -0700
Date:   Wed, 5 Jun 2019 22:31:17 +0800
From:   Philip Li <philip.li@intel.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, lkp@01.org, pmladek@suse.com,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, jpoimboe@redhat.com
Subject: Re: [LKP] livepatching selftests failure on current master branch
Message-ID: <20190605143117.GC19267@intel.com>
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jun 05, 2019 at 09:48:02AM -0400, Joe Lawrence wrote:
> On 5/17/19 10:17 AM, Miroslav Benes wrote:
> >Hi,
> >
> >I noticed that livepatching selftests fail on our master branch
> >(https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).
> >
> >...
> 
> [ adding lkp@01.org to this email ]
> 
> lkp folks, I was wondering if the kernel selftests were included as
> part of the test-bot and if so, do we need to do anything specific
yes, kernel selftest is part of regular execution, which includes the livepatching
test. Also the livepatching.git is under our testing. But we may not successfully
bisect all failures.

The mails related to livepatching test or livepatch  in last two months are

https://lists.01.org/pipermail/lkp/2019-April/010026.html
https://lists.01.org/pipermail/lkp/2019-May/010218.html

Thanks

> to include the livepatching selftests?
> 
> Thanks,
> 
> -- Joe
> _______________________________________________
> LKP mailing list
> LKP@lists.01.org
> https://lists.01.org/mailman/listinfo/lkp
