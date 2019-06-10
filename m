Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC9693B778
	for <lists+live-patching@lfdr.de>; Mon, 10 Jun 2019 16:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390868AbfFJOeO (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Mon, 10 Jun 2019 10:34:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:37104 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390812AbfFJOeO (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 10 Jun 2019 10:34:14 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Jun 2019 07:34:14 -0700
X-ExtLoop1: 1
Received: from pl-dbox.sh.intel.com (HELO intel.com) ([10.239.13.128])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Jun 2019 07:34:12 -0700
Date:   Mon, 10 Jun 2019 22:36:13 +0800
From:   Philip Li <philip.li@intel.com>
To:     Joe Lawrence <joe.lawrence@redhat.com>
Cc:     live-patching@vger.kernel.org, lkp@01.org, pmladek@suse.com,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, jpoimboe@redhat.com
Subject: Re: [LKP] livepatching selftests failure on current master branch
Message-ID: <20190610143613.GB20569@intel.com>
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
 <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
 <20190606004943.GA30795@intel.com>
 <95d6fe2a-595b-c73c-4ec0-af02eeaf29e4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <95d6fe2a-595b-c73c-4ec0-af02eeaf29e4@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Jun 06, 2019 at 02:43:43PM -0400, Joe Lawrence wrote:
> On 6/5/19 8:49 PM, Philip Li wrote:
> >On Wed, Jun 05, 2019 at 10:51:53AM -0400, Joe Lawrence wrote:
> >>Do the tests only run for unique commits (ie, will it skip when
> >>livepatching.git updates/merges latest linux tree ??)
> >it will not skip, though we are not testing commit by commit. If the issue
> >is found, and bisect to the bad commit, we will report to author of that
> >commit for information.
> 
> Sorry, I'm not following along, let me rephrase my question...
sorry for late response, i was taken a few days off.

> 
> This is the rough timeline that recently occurred:
> 
> - changes were made to stacktracing API
> -- one commit affected livepatching and broke a selftest
i assume this is another kernel tree, not necessary the livepatch
kernel tree. This tree may or may not be in our monitor list.
- if not, we can't report is before linus pull.
- if yes, we should be able to detect the failure in normal situation,
and trigger a bisect. But due to how we run the testing internally,
it sometimes can fail to trigger bisect or bisect successfully.

> -- Linus pulled the changes
> - the livepatching tree updated its master to Linus tree
> -- Miroslav noticed that self-tests were broken in the livepatch tree
> -- we fixed up the stacktracing API, pushed up to Linus
> -- all is good now
> 
> Could the 0-day bot testing have helped us spot the self-test
> breakage before Linus pulled or when the livepatching tree updated?
This is similar to previous answer. If the error is not fixed, and exists
in any tree under 0day's monitor, we can figure out the culprit patch.

For now, we will have our best effort to detect regression as many as
possible, while it is not reaching 100% for the test suites we have.

> 
> Thanks,
> 
> -- Joe
