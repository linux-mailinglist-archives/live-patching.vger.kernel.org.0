Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24DE1518663
	for <lists+live-patching@lfdr.de>; Tue,  3 May 2022 16:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbiECOVc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 May 2022 10:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236337AbiECOVb (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 May 2022 10:21:31 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1211F24945
        for <live-patching@vger.kernel.org>; Tue,  3 May 2022 07:17:59 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i1so8932459plg.7
        for <live-patching@vger.kernel.org>; Tue, 03 May 2022 07:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9TEicqUAE63I8+bhURtXZYPHnUpdWS7u5S5vguxpyrQ=;
        b=SvUvmzPnXmKqSMLga4gHcCBwanXiyia8gN9hvPGRlLu2ulpt8/vIgmTJjuCOGEOTmn
         j34uWuews12zyFcQYo2azjKqZTlqyAgiAW9KGyg/rroHrDqy4UcxVtJQM9GHICf4I9hF
         YX0+ySAO+0aArcPV2b3f7n7dU551X4uFF58Ye8CQKwcNpZLKkEALYpEq2YmEriMsq6/+
         kbQBuUtKlXihC92w+sIrdgXeEC/rs6dxjRW0lcaIwk9Ir8C9uWfv8vHMp5g5JRswMog2
         yCY95+ffcBTM791ByG3Rsnotl2nbewtT+jDQFLaYE8aHI9UB9z14PAztGdkeMLfU7dJP
         +E4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9TEicqUAE63I8+bhURtXZYPHnUpdWS7u5S5vguxpyrQ=;
        b=pFgtIIKHkvDzsfDzFdexqzBSSkFB1/ocgoYfkeYw5R0Kk7j8tVulI1l45gEBmRjcSo
         ACBit+2NcU1tRKhKvbN9TMZBRXy0yC9iZiNkOdDixr3KELlqXBvhRHdwPJX69D3ukPzY
         S39CUuSgt/jYK2kvOxJoWliPJpNq9cUG+Fi0A9WIT6E7IcXH88H9EgGxhxVDW4iHbzCN
         P3KYBwPWC4NBHlDnCnkhHcMCpCOrYUKvNjpGRLC01ISuIXQiQVSVh0BONtAi0Hc/4OqV
         NCuYLoLIT0JiL/kbDL6Q6VRCx1v2zW9LojIpJtpycvKk7mx8n9WvgEX+CEW5h3oPD9Ht
         lxSQ==
X-Gm-Message-State: AOAM530V1bpVGODhd2z3ThGynMDxcSd87/UoGhVzGmo71KXmVuv8p++Y
        b/S2FxePETsquvsQb6rPmty5fA==
X-Google-Smtp-Source: ABdhPJyTwTDHJdiiDTN0Dsj4FBQNu42qUygQhMEnNazehdA1ziyJz/asbePyPbuIpLAhUBSYrSRl3w==
X-Received: by 2002:a17:90b:4b83:b0:1dc:93c0:b9fc with SMTP id lr3-20020a17090b4b8300b001dc93c0b9fcmr114780pjb.103.1651587477619;
        Tue, 03 May 2022 07:17:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c24-20020a17090abf1800b001cd4989ff44sm1408334pjs.11.2022.05.03.07.17.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 07:17:57 -0700 (PDT)
Date:   Tue, 3 May 2022 14:17:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Seth Forshee <sforshee@digitalocean.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] entry/kvm: Make vCPU tasks exit to userspace when a
 livepatch is pending
Message-ID: <YnE5kTeGmzKkDTWx@google.com>
References: <20220503125729.2556498-1-sforshee@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503125729.2556498-1-sforshee@digitalocean.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 03, 2022, Seth Forshee wrote:
> A livepatch migration for a task can only happen when the task is
> sleeping or it exits to userspace. This may happen infrequently for a
> heavily loaded vCPU task, leading to livepatch transition failures.
> 
> Fake signals will be sent to tasks which fail to migrate via stack
> checking. This will cause running vCPU tasks to exit guest mode, but
> since no signal is pending they return to guest execution without
> exiting to userspace. Fix this by treating a pending livepatch migration
> like a pending signal, exiting to userspace with EINTR. This allows the
> migration to complete, and userspace should re-excecute KVM_RUN to
> resume guest execution.
> 
> In my testing, systems where livepatching would timeout after 60 seconds
> were able to load livepatches within a couple of seconds with this
> change.
> 
> Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> ---
>  kernel/entry/kvm.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> index 9d09f489b60e..efe4b791c253 100644
> --- a/kernel/entry/kvm.c
> +++ b/kernel/entry/kvm.c
> @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
>  				task_work_run();
>  		}
>  
> -		if (ti_work & _TIF_SIGPENDING) {
> +		/*
> +		 * When a livepatch migration is pending, force an exit to

Can the changelog and comment use terminology other than migration?  Maybe "transition"?
That seems to be prevelant through the livepatch code and docs.  There are already
too many meanings for "migration" in KVM, e.g. live migration, page migration, task/vCPU
migration, etc...

> +		 * userspace as though a signal is pending to allow the
> +		 * migration to complete.
> +		 */
> +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {

_TIF_PATCH_PENDING needs to be in XFER_TO_GUEST_MODE_WORK too, otherwise there's
no guarantee KVM will see the flag and invoke xfer_to_guest_mode_handle_work().

>  			kvm_handle_signal_exit(vcpu);
>  			return -EINTR;
>  		}
> -- 
> 2.32.0
> 
