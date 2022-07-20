Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B6557BBB8
	for <lists+live-patching@lfdr.de>; Wed, 20 Jul 2022 18:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233673AbiGTQqM (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 20 Jul 2022 12:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233067AbiGTQqI (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 20 Jul 2022 12:46:08 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1F34D171;
        Wed, 20 Jul 2022 09:46:07 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id a5so26910889wrx.12;
        Wed, 20 Jul 2022 09:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=AZtADZMgvtkBCIS3LAqwVrSV9dMCa75z9Sz8LnDoOZo=;
        b=F4eDRekK60FmXBYorH5UrWwF5oNEkE4DQUpDZi9I4zIz/11lNlPFUKupDgG71M7NQK
         8xShZmQi6qaiKl9QLmJndgt3Wc9jhhBue6t1tFlw24Xu31wXGUUxWii3ZfGFUj1lUbC9
         m8n50YA56LsA1bse7WSKej5UwEQTHqgPOyBauh0SllvURhifW0qpsNZEqQC9T4KcrfaD
         dbbRJ3j3FjmE1ltZtXZHsDVJOoutBOTAYt2lg6McVaKMGLDdx8pVF3EG9enVFs0xPMSI
         eTEQYAxCFNOpIhcjmbQjJi3l0NLQnbE5wFiyOAx3lQOH/MfBSDMHLwq9kAtrGSB3Zvfk
         lrCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=AZtADZMgvtkBCIS3LAqwVrSV9dMCa75z9Sz8LnDoOZo=;
        b=LZ6YxSjWwyeCx3z/GN8Sxy1TBzADlkucbEdD+3Ex5/iDFlIuyopo/OtBLJzFRj7OgK
         cdKhl87dqIYV4csslInXDnGKTiJ4n+D9XIOWQpAHTi86g9VnsGBVqj2Wlodwv4ka+/le
         vp1EjgaSTJF/AinOoYMpYz3Ftl6flB5l2YgRnxJoB0sZbzKDlV4iHGWFSMA5EvLIgSFW
         I4WHfJe261smAKtm2q/8JNOUamO+qNXSOpCo9xw2E+cUGrwkWnso9UDIes+ERdh1usCq
         heSzi7c191wxevGNNtPpaJsvO5kVtqOgXaQBK9u2NW0/O9vkjw6HbTK6tXdqEdCgjE72
         37Aw==
X-Gm-Message-State: AJIora9H1JZtNakhPlJSHDG3pgVo9gV74tk5EzT3xTiaCWc9wbc5uYFs
        Lep8zx5SEnBmiT/LVFXe+w==
X-Google-Smtp-Source: AGRyM1sJGR02ktTNDO/5V/8b0J7NeLfgLZAQKhP26fn+FEGkv5+s4DYNVKTfEGxjHlbkqQOROaICnw==
X-Received: by 2002:adf:f705:0:b0:21d:74fa:c043 with SMTP id r5-20020adff705000000b0021d74fac043mr32474671wrp.77.1658335565829;
        Wed, 20 Jul 2022 09:46:05 -0700 (PDT)
Received: from localhost.localdomain ([46.53.253.107])
        by smtp.gmail.com with ESMTPSA id w7-20020a1cf607000000b003a31f1edfa7sm3038915wmc.41.2022.07.20.09.46.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:46:04 -0700 (PDT)
Date:   Wed, 20 Jul 2022 19:46:02 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     mingo@redhat.com, linux-kernel@vger.kernel.org,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>, live-patching@vger.kernel.org
Subject: Re: ftrace_kill() leads to kmalloc-512 UAF
Message-ID: <YtgxSs79D0r5s4Ch@localhost.localdomain>
References: <YtgdsW8UBSwCKtQW@localhost.localdomain>
 <20220720121102.6cac8f1d@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220720121102.6cac8f1d@gandalf.local.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Jul 20, 2022 at 12:11:02PM -0400, Steven Rostedt wrote:
> 
> [ Adding live kernel patching folks ]
> 
> On Wed, 20 Jul 2022 18:22:25 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > I'm debugging crash of our product which does live kernel patching together
> > with ISV security scanner which uses ftrace kprobes to do whatever it does.
> > 
> > What happens is that is ftrace ever detects .text change, refuses to patch
> > and prints a warning with FTRACE_WARN_ON_ONCE() then there is reliable way
> > to cause UAF on kmalloc-512 cache by trying to register kprobe with
> > perf_event_open() and then unregistering it by exiting the process.
> > 
> > 1) live kernel patching happens, first instruction of some function changes
> 
> But live kernel patching uses ftrace to do this, so the question remains,
> why doesn't ftrace know about this change?

That a line from our product which changes first instruction of the function.

> > 2) kprobe on that function is registered with perf_event_open()
> > 
> > 	WARNING: CPU: 5 PID: 2109 at kernel/trace/ftrace.c:1853 ftrace_bug+0x25d/0x270
> > 	 [<ffffffff811638ed>] ftrace_bug+0x25d/0x270
> > 	 [<ffffffff81065571>] ftrace_replace_code+0x2b1/0x420
> > 	 [<ffffffff81163f9a>] ftrace_modify_all_code+0x6a/0xb0
> > 	 [<ffffffff810656f0>] arch_ftrace_update_code+0x10/0x20
> > 	 [<ffffffff81164077>] ftrace_run_update_code+0x17/0x70
> > 	 [<ffffffff81165512>] ftrace_set_hash+0x1c2/0x1f0
> > 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> > 	 [<ffffffff8126fee0>] ? SyS_dup2+0x60/0x60
> > 	 [<ffffffff811655a0>] ftrace_set_filter_ip+0x60/0x70
> > 	 [<ffffffff8179624c>] arm_kprobe+0x9c/0x140
> > 	 [<ffffffff81796368>] enable_kprobe+0x78/0xa0
> > 	 [<ffffffff81187bab>] enable_trace_kprobe+0x7b/0x120
> > 	 [<ffffffff81797e5f>] kprobe_register+0x2f/0x60
> > 	 [<ffffffff8118348a>] perf_trace_event_init+0x1aa/0x230
> > 	 [<ffffffff811836b7>] perf_kprobe_init+0xa7/0xf0
> > 	 [<ffffffff811a8919>] perf_kprobe_event_init+0x49/0x70
> > 	 [<ffffffff811aa569>] perf_try_init_event+0x99/0xc0
> > 	 [<ffffffff811b29f2>] perf_init_event+0x92/0x150
> > 	 [<ffffffff811b2fa1>] perf_event_alloc+0x4f1/0x910
> > 	 [<ffffffff811b3789>] SYSC_perf_event_open+0x3c9/0xe50
> > 	 [<ffffffff811b4679>] SyS_perf_event_open+0x9/0x10
> > 	 [<ffffffff81799f92>] system_call_fastpath+0x25/0x2a
> > 	ftrace failed to modify [<ffffffff8126fee0>] SyS_dup+0x0/0x120
> > 	 actual: e9:4b:50:2e:3f
> > 
> 
> Again, why did the above happen. This is a kernel bug that needs to be
> fixed. Everything else after this is unimportant, because it's just fall
> out to the above bug.

I'll double check what we (not KLP) do and maybe even what KLP does!
