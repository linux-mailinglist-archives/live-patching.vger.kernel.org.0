Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C813496CB
	for <lists+live-patching@lfdr.de>; Thu, 25 Mar 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbhCYQ37 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 25 Mar 2021 12:29:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCYQ3q (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 25 Mar 2021 12:29:46 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C647C06174A
        for <live-patching@vger.kernel.org>; Thu, 25 Mar 2021 09:29:46 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id k8so2473925iop.12
        for <live-patching@vger.kernel.org>; Thu, 25 Mar 2021 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PSF0pivwzy3fBYbfzo8IgvCNBR/Hw3crvEop98fZXCg=;
        b=n/ll6FIqeHJKlpZG8seLI/5tmNYd1JNATCmHWlxI1aibGm2zob8+SEERP8L/XkU0UT
         aoPUovkhVPFlyxakHzue+mQ+SDVZK0BPhyCywSivUGhdOeewfRNOFPdqFRk3qavaoE2A
         KWhPPy8RE/oAsQW3LO6DUnC4LGTsetvZt5ZKwI96360hTpqwkl5a136I6bdXoXAVJ5OT
         yXVPCmcYQLEeUYYAU4D1u0aGZpSI6CmlLdCy2nnAPAnLHnl7f6EUu8MOe2UaMSrvnQdm
         vUHd0tJJqp81YYy3K1jLxT1LMIvoF6WiwLHVFYNrigG4Xhu3ADxWsUhtzWgPaiSBk+1g
         nrDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PSF0pivwzy3fBYbfzo8IgvCNBR/Hw3crvEop98fZXCg=;
        b=OuiQ1P/2KQ1MFff29VC3ks5GYOrSzqS+AibWqQnQtLWbHGOj9IjcQT0Ek06DjirvWY
         NOz7InFh84HruXuQnkEu/NaGUeCLaQPHw39prixeyrkxK0BI4KqDMb2YVyVh85srR8nk
         4uafZ90qBvQWVzv1IJvFRiFgry51p0rvmqmRlfgtNm8AD3OtW6p1jysGNZVKBiICHttc
         B3cIlcvCOn1thpo92u683DbrYrcM5lwYrzCeVAoCgL7z03OkvU7MTLz8+nXusKQi67k+
         bW49rvt2eb9IOGWVo7L+ML/r/+0E4k9ZraxeUfU1tsBJ/WDk2jlVZqaGDAqFx6ny45is
         CG3A==
X-Gm-Message-State: AOAM5320OCiqvmeE6nWoE+3szgIFtnBF7fsN+thdVa3DdlWKaeQUXZY2
        Vz6x4nK9t2UySfYwW46wUAy/9w==
X-Google-Smtp-Source: ABdhPJydx5+yyeRQGFt1qi82utbriCQ1JZmy6qkm1FzVoBRb9wH/6bcFzkNbgwRAr4rpxnTwHrw3Ag==
X-Received: by 2002:a05:6602:26cc:: with SMTP id g12mr6746649ioo.169.1616689785483;
        Thu, 25 Mar 2021 09:29:45 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m1sm2667686ilh.69.2021.03.25.09.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Mar 2021 09:29:45 -0700 (PDT)
Subject: Re: [PATCH] livepatch: klp_send_signal should treat PF_IO_WORKER like
 PF_KTHREAD
To:     Dong Kai <dongkai11@huawei.com>, jpoimboe@redhat.com,
        jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        joe.lawrence@redhat.com
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210325014836.40649-1-dongkai11@huawei.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <832b5870-b926-3ccb-155d-3c364ee5508d@kernel.dk>
Date:   Thu, 25 Mar 2021 10:29:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210325014836.40649-1-dongkai11@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On 3/24/21 7:48 PM, Dong Kai wrote:
> commit 15b2219facad ("kernel: freezer should treat PF_IO_WORKER like
> PF_KTHREAD for freezing") is to fix the freezeing issue of IO threads
> by making the freezer not send them fake signals.
> 
> Here live patching consistency model call klp_send_signals to wake up
> all tasks by send fake signal to all non-kthread which only check the
> PF_KTHREAD flag, so it still send signal to io threads which may lead to
> freezeing issue of io threads.
> 
> Here we take the same fix action by treating PF_IO_WORKERS as PF_KTHREAD
> within klp_send_signal function.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

