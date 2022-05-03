Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1560518989
	for <lists+live-patching@lfdr.de>; Tue,  3 May 2022 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239321AbiECQVi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 3 May 2022 12:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239313AbiECQVh (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 3 May 2022 12:21:37 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28502ED78
        for <live-patching@vger.kernel.org>; Tue,  3 May 2022 09:18:04 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id m11so18640884oib.11
        for <live-patching@vger.kernel.org>; Tue, 03 May 2022 09:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q51Ia3tetkXHUbkcfKD8S+gdtewHxa7+IUzoOiuzmQM=;
        b=DXNemHdAsSJnzRfAFmFJDu7rxBi3j2CgdmhDiTTYFUQVZd81cb6Uc+goqkxzhoaGaE
         rc1WCcIRmRkCpMkO0bJFB3uqZkeysudG4ESGLjj/ionJPTbCH6O/8VdViXZbrD2f4QEs
         3SJHX2OkoKRviER0B91sBk/C0juHWnWJQLLHU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q51Ia3tetkXHUbkcfKD8S+gdtewHxa7+IUzoOiuzmQM=;
        b=GIKDWegFcrx1NqoEpLMvgiPGKAaJyGvRk7mST1PXc2+4clGlj0IPqzl+RgSUcCPCwA
         Jm+xLrftukBduDkMCyJKbEEO4JZd/txL8oZcNHnhbF7Z/6NqlmuCqaOnpfODrQLXyUgk
         wRxT11cCWta3I2YAqBiFO9P09kvJxqPg53p54gX+2kQHPJWuTS7B8zD7Iqr9offQa9PY
         TdeRSrMV664hMLeArVCQtlqCHzpMpiHZSGbgMlq2wJ3TfJa8DfI7Zq7nrQh28osN8u42
         sLZnlghgW15PA8add1AQehpVbEb30sgpYe8s5r7rJIvfHjVL9DKUEI6yOdnG8ciCF4US
         qrkA==
X-Gm-Message-State: AOAM531qNdaixQnIyz4K1VkCRS88qPkJS1jYK4Jl+1dOibzRgX8WV3kG
        ICiqmkXahlmrOqnk3/a9RQy2hA==
X-Google-Smtp-Source: ABdhPJzaqQPI/1igl+iB0OUCnACAJFry6dBnUhBprcHogtJiHS4VmyVxX1E5pHmdYanKyutyiI/1rA==
X-Received: by 2002:a05:6808:1202:b0:322:dc37:2c3b with SMTP id a2-20020a056808120200b00322dc372c3bmr2217794oil.298.1651594683941;
        Tue, 03 May 2022 09:18:03 -0700 (PDT)
Received: from localhost ([2605:a601:ac0f:820:80d8:f53c:c84d:deaa])
        by smtp.gmail.com with ESMTPSA id 8-20020a056870124800b000e686d13888sm7369543oao.34.2022.05.03.09.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 09:18:03 -0700 (PDT)
Date:   Tue, 3 May 2022 11:18:02 -0500
From:   Seth Forshee <sforshee@digitalocean.com>
To:     Sean Christopherson <seanjc@google.com>
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
Message-ID: <YnFVugyU8+XBVRqL@do-x1extreme>
References: <20220503125729.2556498-1-sforshee@digitalocean.com>
 <YnE5kTeGmzKkDTWx@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnE5kTeGmzKkDTWx@google.com>
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue, May 03, 2022 at 02:17:53PM +0000, Sean Christopherson wrote:
> On Tue, May 03, 2022, Seth Forshee wrote:
> > A livepatch migration for a task can only happen when the task is
> > sleeping or it exits to userspace. This may happen infrequently for a
> > heavily loaded vCPU task, leading to livepatch transition failures.
> > 
> > Fake signals will be sent to tasks which fail to migrate via stack
> > checking. This will cause running vCPU tasks to exit guest mode, but
> > since no signal is pending they return to guest execution without
> > exiting to userspace. Fix this by treating a pending livepatch migration
> > like a pending signal, exiting to userspace with EINTR. This allows the
> > migration to complete, and userspace should re-excecute KVM_RUN to
> > resume guest execution.
> > 
> > In my testing, systems where livepatching would timeout after 60 seconds
> > were able to load livepatches within a couple of seconds with this
> > change.
> > 
> > Signed-off-by: Seth Forshee <sforshee@digitalocean.com>
> > ---
> >  kernel/entry/kvm.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
> > index 9d09f489b60e..efe4b791c253 100644
> > --- a/kernel/entry/kvm.c
> > +++ b/kernel/entry/kvm.c
> > @@ -14,7 +14,12 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
> >  				task_work_run();
> >  		}
> >  
> > -		if (ti_work & _TIF_SIGPENDING) {
> > +		/*
> > +		 * When a livepatch migration is pending, force an exit to
> 
> Can the changelog and comment use terminology other than migration?  Maybe "transition"?
> That seems to be prevelant through the livepatch code and docs.  There are already
> too many meanings for "migration" in KVM, e.g. live migration, page migration, task/vCPU
> migration, etc...

"Transition" is used a lot, but afaict it refers to the overall state of
the livepatch. "Migrate" is used a lot less, but it always seems to
refer to patching a single task, which is why I used that term. But I
can see the opportunity for confusion, so I'll reword it.

> 
> > +		 * userspace as though a signal is pending to allow the
> > +		 * migration to complete.
> > +		 */
> > +		if (ti_work & (_TIF_SIGPENDING | _TIF_PATCH_PENDING)) {
> 
> _TIF_PATCH_PENDING needs to be in XFER_TO_GUEST_MODE_WORK too, otherwise there's
> no guarantee KVM will see the flag and invoke xfer_to_guest_mode_handle_work().

Yes, you are right. I was relying on the livepatch code setting
_TIF_NOTIFY_SIGNAL for vCPU tasks which were running, but it would be
better to have _TIF_PATCH_PENDING in XFER_TO_GUEST_MODE_WORK too.

Thanks,
Seth

> 
> >  			kvm_handle_signal_exit(vcpu);
> >  			return -EINTR;
> >  		}
> > -- 
> > 2.32.0
> > 
