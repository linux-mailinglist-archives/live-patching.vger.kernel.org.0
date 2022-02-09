Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26FD4AF5BC
	for <lists+live-patching@lfdr.de>; Wed,  9 Feb 2022 16:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236276AbiBIPtf (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 9 Feb 2022 10:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231215AbiBIPtf (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 9 Feb 2022 10:49:35 -0500
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D1B2C0613C9;
        Wed,  9 Feb 2022 07:49:37 -0800 (PST)
Received: by mail-qv1-f48.google.com with SMTP id a28so2087842qvb.10;
        Wed, 09 Feb 2022 07:49:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6rJAbVelhQQqOi4Wi8RowpEmM/jPKLnf8zJHod9DfXE=;
        b=HzpBVcbLBtocPS351tTnbfP7FVvCiJkYNb6vfwQoLZvIwkwqPLr4tWYqWRs+Q6kxOG
         yH7Ea4BnDpvzswT+9TBEVj0VteaU5ItsL5U5RUOiKbUWzsvCviPiLA+DfCxW0xwIlMnF
         sNC9UWOpMNHsTVW4YL+dmKaJIZp1KJRWpzUm2HXCRlP286Q020TxoiT3pkUrwnk6kL6H
         egObFTSlYrU53Fv4zR91h9EoqnHquK0iGUm1v9Lm3LjS5zda1otwQ3T9iC4UrJAi20eR
         fEGXkDfRrz2B6lu5oD/NJGbOTvOoUbDHxUy8Yo5v0kcc1F0ERmDie3/zoc9lKm4djzql
         GIIA==
X-Gm-Message-State: AOAM531TXVpNtBxuz3yDgRaCZZ/LeDe+txDGESG9nvHU4Qu9LE/jQKoA
        nkxvqiRAFYPM6NVnPrK/0CY=
X-Google-Smtp-Source: ABdhPJwNean9u5Ca2umfiWKsCkYJcJSZ/Jv1WmguJWQI1SvjDKLVIrI0ajr9CzZ+x75I9PLc2cnG3g==
X-Received: by 2002:a05:6214:d06:: with SMTP id 6mr1953893qvh.96.1644421776362;
        Wed, 09 Feb 2022 07:49:36 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-015.fbsv.net. [2a03:2880:20ff:f::face:b00c])
        by smtp.gmail.com with ESMTPSA id f20sm9330176qtf.39.2022.02.09.07.49.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 07:49:36 -0800 (PST)
Date:   Wed, 9 Feb 2022 07:49:34 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v2] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <20220209154934.5w5k5tqcqldbfjt3@dev0025.ash9.facebook.com>
References: <20220203233205.1554034-1-void@manifault.com>
 <20220204205625.2628328-1-void@manifault.com>
 <20220209130233.GB8279@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209130233.GB8279@pathway.suse.cz>
User-Agent: NeoMutt/20211029
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed, Feb 09, 2022 at 02:02:33PM +0100, Petr Mladek wrote:
> Hmm, test-ftrace.sh fails with this patch:
> 
> localhost:/prace/kernel/linux/tools/testing/selftests/livepatch # ./test-ftrace.sh 
> TEST: livepatch interaction with ftrace_enabled sysctl ... SKIP: failed to set kernel.ftrace_enabled=0
> 
> This is the dmesg output:
> 
> [  436.176433] ===== TEST: livepatch interaction with ftrace_enabled sysctl =====
> [  436.186942] livepatch: kernel.ftrace_enabled = 0
> [  436.187854] % modprobe test_klp_livepatch
> [  436.217657] livepatch: enabling patch 'test_klp_livepatch'
> [  436.218467] livepatch: 'test_klp_livepatch': initializing patching transition
> [  436.219679] livepatch: failed to register ftrace handler for function 'cmdline_proc_show' (-16)
> [  436.221003] livepatch: failed to patch object 'vmlinux'
> [  436.221786] livepatch: failed to enable patch 'test_klp_livepatch'
> [  436.222716] livepatch: 'test_klp_livepatch': canceling patching transition, going to unpatch
> [  436.223955] livepatch: 'test_klp_livepatch': completing unpatching transition
> [  436.225476] livepatch: 'test_klp_livepatch': unpatching complete
> [  436.273295] modprobe: ERROR: could not insert 'test_klp_livepatch': Device or resource busy
> [  436.284522] livepatch: kernel.ftrace_enabled = 1
> [  436.305353] % modprobe test_klp_livepatch
> [  436.334929] livepatch: enabling patch 'test_klp_livepatch'
> [  436.335781] livepatch: 'test_klp_livepatch': initializing patching transition
> [  436.338099] livepatch: 'test_klp_livepatch': starting patching transition
> [  438.082707] livepatch: 'test_klp_livepatch': completing patching transition
> [  438.084106] livepatch: 'test_klp_livepatch': patching complete
> [  438.199997] livepatch: sysctl: setting key "kernel.ftrace_enabled": Device or resource busy
> [  438.201249] kernel.ftrace_enabled = 1
> [  438.201929] SKIP: failed to set kernel.ftrace_enabled=0
> 
> 
> The problem is the 2nd "set_ftrace_enabled 0" call in
> tools/testing/selftests/livepatch/test-ftrace.sh
> 
> It is done when "test_klp_livepatch" is loaded. ftrace could not be
> disabled because it is used by the livepatch. It is expected behavior
> and the test should succeed in this case.

Ah, I missed this because in my configuration I was expecting the test to
be skipped. What do we think is the preferred alternative?  Perhaps we
could add an optional argument to set_trace_enabled() that specifies the
expected value of kernel.ftrace_enabled after invoking sysctl?

What do you think of something like this:

+
+	if [[ "$result" != "kernel.ftrace_enabled = $1" ]]; then
+		if [[ -z "$2" || "$2" == "$1" ]]; then
+			skip "failed to set kernel.ftrace_enabled=$1"
+		fi
+	elif [[ -n "$2" && "$2" != "$1" ]]; then
+		die "Unexpectedly set kernel.ftrace_enabled=$1"
+	fi

test-ftrace.sh could then specify 'set_ftrace_enabled 0 1' when validating
that ftrace can't be disabled when it's being used by livepatch.  Not sure
if it makes sense to use skip() in the first case and die() in the latter
case, but being able to unexpectedly set kernel.ftrace_enabled seems more
problematic and within the control of the test than not being able to set
it. I could also just leave off the elif case as it's not needed for the
test suite as it exists today, but I think it makes the
set_ftrace_enabled() API more consistent and intuitive.

Thanks,
David
