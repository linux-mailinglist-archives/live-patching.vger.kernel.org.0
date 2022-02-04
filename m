Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AF94AA126
	for <lists+live-patching@lfdr.de>; Fri,  4 Feb 2022 21:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiBDUaW (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 4 Feb 2022 15:30:22 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30855 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234766AbiBDUaP (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 4 Feb 2022 15:30:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644006605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0qZZ895hE4+IyDyf9RKZqhMfNZ+RmkkBr6db1m6Cv58=;
        b=ZB+Piu3JBvwSyyL9Gc5nnIPZoc4UK/SfGJ5vDzd7dTCLp3QyiMGfth/6ZIHYzp6mDvNJca
        t0C/ME3mckrc4x8wZtISjg+h9yv2cYO/3vSm44r9Jroj5ckpjUne9tAl6sA2hmg8j0LEO1
        1UehZ0Wt4fuYpOHexXpnQMZrzTEyotQ=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-546-nF7e49LoPgOJrFouWFXyqg-1; Fri, 04 Feb 2022 15:30:05 -0500
X-MC-Unique: nF7e49LoPgOJrFouWFXyqg-1
Received: by mail-qt1-f199.google.com with SMTP id z1-20020ac87ca1000000b002d11bc8d795so5492493qtv.17
        for <live-patching@vger.kernel.org>; Fri, 04 Feb 2022 12:30:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0qZZ895hE4+IyDyf9RKZqhMfNZ+RmkkBr6db1m6Cv58=;
        b=BkQroCyXZjrrB9ZlDJ7tG3ivgX5/BsC216/h9rVVOMA5H+FSTC1JHyeAvevYpUYbWD
         N3oL7Tiory8RtbRmMBKlMgL7YeajsD/vXfzmrwnf5WwJkiwmVfSGxcEZPfO7TVs/+YK9
         FPcmuW+gBRw7QpYyQMB76vu9IQsmmzuj74qIny9N3iO4mN0KDWMKM5W2hFuRumsk6HxV
         jcJrOEvoIksF4SPxADHtZFAgzcVxX3VCGX11UwCn0xteU1Pk2ILepYU7xVbvzjQtd5mx
         aMtWiFdQf6Wcl5vIR96+UVLttXYvGSuUKAX3msO2MxWj4BQ5o4dW2NGk4PWlQzopeiyC
         QbsQ==
X-Gm-Message-State: AOAM5313wBkUe0c29lVFDFb11DusPuYl6WQhU0uIkObNz/OIX4eYj0Ep
        o6afb+xE+k2sWwbWOEnLXy9HWHmoiJgwpyIA9Pgly7tm6d/y3BYoq+wyhJlqIF5PwZH6A15nrDz
        IWbEJ3udsYEQIKUME5Du4vXwMKg==
X-Received: by 2002:a05:622a:487:: with SMTP id p7mr566848qtx.426.1644006604259;
        Fri, 04 Feb 2022 12:30:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw1UMBxjTwBEHdtzynZ3uKSgjtKp1PwnezgHhucfSvVQUYYbFNQz31lNcRwIhEHiqbMwMe+rA==
X-Received: by 2002:a05:622a:487:: with SMTP id p7mr566833qtx.426.1644006604003;
        Fri, 04 Feb 2022 12:30:04 -0800 (PST)
Received: from [192.168.1.9] (pool-68-163-101-245.bstnma.fios.verizon.net. [68.163.101.245])
        by smtp.gmail.com with ESMTPSA id z17sm1716843qta.11.2022.02.04.12.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Feb 2022 12:30:03 -0800 (PST)
To:     David Vernet <void@manifault.com>, live-patching@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpoimboe@redhat.com,
        pmladek@suse.com, jikos@kernel.org, mbenes@suse.cz, corbet@lwn.net
Cc:     kernel-team@fb.com
References: <20220203233205.1554034-1-void@manifault.com>
From:   Joe Lawrence <joe.lawrence@redhat.com>
Subject: Re: [PATCH] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <917650f7-4e8c-4643-77d3-45d1ebbb217f@redhat.com>
Date:   Fri, 4 Feb 2022 15:30:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220203233205.1554034-1-void@manifault.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 2/3/22 6:32 PM, David Vernet wrote:
> livepatch has a set of selftests that are used to validate the behavior of
> the livepatching subsystem.  One of the testcases in the livepatch
> testsuite is test-ftrace.sh, which among other things, validates that
> livepatching gracefully fails when ftrace is disabled.  In the event that
> ftrace cannot be disabled using 'sysctl kernel.ftrace_enabled=0', the test
> will fail later due to it unexpectedly successfully loading the
> test_klp_livepatch module.
> 
> While the livepatch selftests are careful to remove any of the livepatch
> test modules between testcases to avoid this situation, ftrace may still
> fail to be disabled if another trace is active on the system that was
> enabled with FTRACE_OPS_FL_PERMANENT.  For example, any active BPF programs
> that use trampolines will cause this test to fail due to the trampoline
> being implemented with register_ftrace_direct().  The following is an
> example of such a trace:
> 
> tcp_drop (1) R I D      tramp: ftrace_regs_caller+0x0/0x58
> (call_direct_funcs+0x0/0x30)
>         direct-->bpf_trampoline_6442550536_0+0x0/0x1000
> 
> In order to make the test more resilient to system state that is out of its
> control, this patch adds a check to set_ftrace_enabled() to skip the tests
> if the sysctl invocation fails.
> 
> Signed-off-by: David Vernet <void@manifault.com>

Hi David,

Thanks for this test case, comments below...

> ---
>  tools/testing/selftests/livepatch/functions.sh | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 846c7ed71556..6857fdcb6b45 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -78,6 +78,12 @@ function set_ftrace_enabled() {
>  	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
>  		 sysctl kernel.ftrace_enabled 2>&1)
>  	echo "livepatch: $result" > /dev/kmsg
> +	# Skip the test if ftrace is busy.  This can happen under normal system
> +	# conditions if a trace is marked as permament.

sp: s/permament/permanent

> +	if [[ "$result" == *"Device or resource busy"* ]]; then
> +		skip "failed to set kernel.ftrace_enabled=$1"
> +	fi
> +

style nit: move the blank line from here to just before the new # Skip
comment

>  }
>  
>  function cleanup() {
> 

Can we be more paranoid and just look for the exact result that we expect:

if [[ "$result" != "kernel.ftrace_enabled = 1" ]]; then
	skip "failed to set kernel.ftrace_enabled=$1"
fi

and that way we catch any other faults.  What do you think?

Thanks,
-- 
Joe

