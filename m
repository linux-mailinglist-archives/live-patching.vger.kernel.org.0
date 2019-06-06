Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5B6D37C6B
	for <lists+live-patching@lfdr.de>; Thu,  6 Jun 2019 20:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbfFFSns (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 6 Jun 2019 14:43:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39862 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726066AbfFFSns (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Thu, 6 Jun 2019 14:43:48 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 34FD52F8BF6;
        Thu,  6 Jun 2019 18:43:48 +0000 (UTC)
Received: from [10.16.196.26] (wlan-196-26.bos.redhat.com [10.16.196.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 321DA61377;
        Thu,  6 Jun 2019 18:43:44 +0000 (UTC)
Subject: Re: [LKP] livepatching selftests failure on current master branch
To:     Philip Li <philip.li@intel.com>
Cc:     live-patching@vger.kernel.org, lkp@01.org, pmladek@suse.com,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, jpoimboe@redhat.com
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
 <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
 <20190606004943.GA30795@intel.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <95d6fe2a-595b-c73c-4ec0-af02eeaf29e4@redhat.com>
Date:   Thu, 6 Jun 2019 14:43:43 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606004943.GA30795@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Thu, 06 Jun 2019 18:43:48 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/5/19 8:49 PM, Philip Li wrote:
> On Wed, Jun 05, 2019 at 10:51:53AM -0400, Joe Lawrence wrote:
>> Do the tests only run for unique commits (ie, will it skip when
>> livepatching.git updates/merges latest linux tree ??)
> it will not skip, though we are not testing commit by commit. If the issue
> is found, and bisect to the bad commit, we will report to author of that
> commit for information.

Sorry, I'm not following along, let me rephrase my question...

This is the rough timeline that recently occurred:

- changes were made to stacktracing API
-- one commit affected livepatching and broke a selftest
-- Linus pulled the changes
- the livepatching tree updated its master to Linus tree
-- Miroslav noticed that self-tests were broken in the livepatch tree
-- we fixed up the stacktracing API, pushed up to Linus
-- all is good now

Could the 0-day bot testing have helped us spot the self-test breakage 
before Linus pulled or when the livepatching tree updated?

Thanks,

-- Joe
