Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EECFA219D3
	for <lists+live-patching@lfdr.de>; Fri, 17 May 2019 16:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728482AbfEQOaN (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 17 May 2019 10:30:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45846 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbfEQOaN (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Fri, 17 May 2019 10:30:13 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C09575724;
        Fri, 17 May 2019 14:30:07 +0000 (UTC)
Received: from [10.18.17.208] (dhcp-17-208.bos.redhat.com [10.18.17.208])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6059C78576;
        Fri, 17 May 2019 14:30:05 +0000 (UTC)
Subject: Re: livepatching selftests failure on current master branch
To:     Miroslav Benes <mbenes@suse.cz>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jikos@kernel.org, jpoimboe@redhat.com, pmladek@suse.com,
        tglx@linutronix.de
References: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Message-ID: <ca57cb3a-cd4b-9d3b-1c67-4b60c4a00cb3@redhat.com>
Date:   Fri, 17 May 2019 10:30:04 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1905171608550.24009@pobox.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 17 May 2019 14:30:12 +0000 (UTC)
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 5/17/19 10:17 AM, Miroslav Benes wrote:
> Hi,
> 
> I noticed that livepatching selftests fail on our master branch
> (https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/).
> 
> ...
> TEST: busy target module ... not ok
> 
> --- expected
> +++ result
> @@ -7,16 +7,24 @@ livepatch: 'test_klp_callbacks_demo': in
>   test_klp_callbacks_demo: pre_patch_callback: vmlinux
>   test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
>   livepatch: 'test_klp_callbacks_demo': starting patching transition
> +livepatch: 'test_klp_callbacks_demo': completing patching transition
> +test_klp_callbacks_demo: post_patch_callback: vmlinux
> +test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
> +livepatch: 'test_klp_callbacks_demo': patching complete
>   % modprobe test_klp_callbacks_mod
>   livepatch: applying patch 'test_klp_callbacks_demo' to loading module
> 'test_klp_callbacks_mod'
>   test_klp_callbacks_demo: pre_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
> +test_klp_callbacks_demo: post_patch_callback: test_klp_callbacks_mod -> [MODULE_STATE_COMING] Full formed, running module_init
>   test_klp_callbacks_mod: test_klp_callbacks_mod_init
>   % rmmod test_klp_callbacks_mod
>   test_klp_callbacks_mod: test_klp_callbacks_mod_exit
> +test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
>   livepatch: reverting patch 'test_klp_callbacks_demo' on unloading module
> 'test_klp_callbacks_mod'
>   test_klp_callbacks_demo: post_unpatch_callback: test_klp_callbacks_mod -> [MODULE_STATE_GOING] Going away
>   % echo 0 > /sys/kernel/livepatch/test_klp_callbacks_demo/enabled
> -livepatch: 'test_klp_callbacks_demo': reversing transition from patching to unpatching
> +livepatch: 'test_klp_callbacks_demo': initializing unpatching transition
> +test_klp_callbacks_demo: pre_unpatch_callback: vmlinux
> +test_klp_callbacks_demo: pre_unpatch_callback: test_klp_callbacks_busy -> [MODULE_STATE_LIVE] Normal state
>   livepatch: 'test_klp_callbacks_demo': starting unpatching transition
>   livepatch: 'test_klp_callbacks_demo': completing unpatching transition
>   test_klp_callbacks_demo: post_unpatch_callback: vmlinux
> 
> ERROR: livepatch kselftest(s) failed
> not ok 1..2 selftests: livepatch: test-callbacks.sh [FAIL]
> 
> which probably means that the consistency model is not in the best shape.
> There were not many livepatch changes in the latest pull request. Stack
> unwinder changes may be connected, so adding Thomas to be aware if it
> leads in this direction.
> 
> Unfortunately, I'm leaving in a minute and will be gone till Wednesday, so
> if someone confirms and wants to investigate, definitely feel free to do
> it.
> 

I will take a look today.  Thanks for reporting.  I hope it's something 
silly in the tests not the consistency model ...

-- Joe
