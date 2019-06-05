Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7330835FA2
	for <lists+live-patching@lfdr.de>; Wed,  5 Jun 2019 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfFEOv4 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 5 Jun 2019 10:51:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728306AbfFEOv4 (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Wed, 5 Jun 2019 10:51:56 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 37ADC30C62A8;
        Wed,  5 Jun 2019 14:51:56 +0000 (UTC)
Received: from [10.16.196.26] (wlan-196-26.bos.redhat.com [10.16.196.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FAD960920;
        Wed,  5 Jun 2019 14:51:54 +0000 (UTC)
Subject: Re: [LKP] livepatching selftests failure on current master branch
To:     Philip Li <philip.li@intel.com>
Cc:     live-patching@vger.kernel.org, lkp@01.org, pmladek@suse.com,
        jikos@kernel.org, Miroslav Benes <mbenes@suse.cz>,
        tglx@linutronix.de, jpoimboe@redhat.com
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
 <c3a528e2-40f1-5a3d-38d7-6acb188bbd88@redhat.com>
 <20190605143117.GC19267@intel.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <e264efb1-0b6e-c860-7a6d-ce92bde8efa2@redhat.com>
Date:   Wed, 5 Jun 2019 10:51:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190605143117.GC19267@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Wed, 05 Jun 2019 14:51:56 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 6/5/19 10:31 AM, Philip Li wrote:
> On Wed, Jun 05, 2019 at 09:48:02AM -0400, Joe Lawrence wrote:
>> On 5/17/19 10:17 AM, Miroslav Benes wrote:
>>> Hi,
>>>
>>> I noticed that livepatching selftests fail on our master branch
>>> (https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).
>>>
>>> ...
>>
>> [ adding lkp@01.org to this email ]
>>
>> lkp folks, I was wondering if the kernel selftests were included as
>> part of the test-bot and if so, do we need to do anything specific
> yes, kernel selftest is part of regular execution, which includes the livepatching
 > test. Also the livepatching.git is under our testing...

Hi Philip,

Good to hear.  My github tree and Josh's kernel.org tree are included as 
(perhaps other livepatching dev trees as well), so the more coverage the 
better :)

>                                                   ... But we may not successfully
> bisect all failures.

That's okay, though I guess I'm not clear why there wasn't an email 
reporting that the livepatching selftests failed after livepatching.git 
was recently updated to include tglx's stack trace fixes.

Do the tests only run for unique commits (ie, will it skip when 
livepatching.git updates/merges latest linux tree ??)

Thanks,

-- Joe
