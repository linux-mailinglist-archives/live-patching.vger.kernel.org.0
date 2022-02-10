Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2E634B1296
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 17:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbiBJQWU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 11:22:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240419AbiBJQWU (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 11:22:20 -0500
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87A81A7;
        Thu, 10 Feb 2022 08:22:20 -0800 (PST)
Received: by mail-qk1-f181.google.com with SMTP id 13so5311621qkd.13;
        Thu, 10 Feb 2022 08:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+GeqGuh981U4ovUDSjvJdu2yKZRMHALTYZnjSh1GDTs=;
        b=fwy/iaExfgOreHfSjTcn3FVGDFlb0Cj9jGrzPQd39XAq+MfmaJbk2DfX2m6t79cvDx
         u8envE+dExuEnavB88J5phYqbx/tnkZ2eisJnvwxCk3s+aIg4wjInrb2nWqqOJiGOcUo
         nH9jQtUiY2S7UIgPOQD3e9y5wGZZy2LNTk663qDqNMkmI99roL7SKOQoQI4QE4Ewsm1c
         AqoZ5sWc4uENLtGEUFd5c/nx9NKo9PxQyYLR6SOp5e5dmzd9XYx5OvK0GERZJPlHTM64
         XjzGn5RuX8enxfJpfDhF/4tGW5GsaScO2IvyS8gos956axzJDWV/UebDphP1OAa3+4E0
         zqsg==
X-Gm-Message-State: AOAM533ql3GlqhJmfsa8UnWMgr1I3mLivniLbFdUBwWw2CFH8ZeSVfFj
        5tTuelImcZgWEtxUxCqMmAA=
X-Google-Smtp-Source: ABdhPJyuUZuhZA63K6TFCv2cuVjLaXfVWmyTaDqapp6THScQOR7ATeNEe0e9ilGyJWzXMkMyxBwZxQ==
X-Received: by 2002:a05:620a:7e9:: with SMTP id k9mr4224181qkk.208.1644510139612;
        Thu, 10 Feb 2022 08:22:19 -0800 (PST)
Received: from dev0025.ash9.facebook.com (fwdproxy-ash-000.fbsv.net. [2a03:2880:20ff::face:b00c])
        by smtp.gmail.com with ESMTPSA id d17sm10343115qkn.84.2022.02.10.08.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:22:19 -0800 (PST)
Date:   Thu, 10 Feb 2022 08:22:15 -0800
From:   David Vernet <void@manifault.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@redhat.com, jikos@kernel.org, mbenes@suse.cz,
        joe.lawrence@redhat.com, corbet@lwn.net, kernel-team@fb.com
Subject: Re: [PATCH v2] livepatch: Skip livepatch tests if ftrace cannot be
 configured
Message-ID: <20220210162215.oupcqlcglfpeqkbp@dev0025.ash9.facebook.com>
References: <20220203233205.1554034-1-void@manifault.com>
 <20220204205625.2628328-1-void@manifault.com>
 <20220209130233.GB8279@pathway.suse.cz>
 <20220209154934.5w5k5tqcqldbfjt3@dev0025.ash9.facebook.com>
 <YgUt4+XGLOB4+0H3@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgUt4+XGLOB4+0H3@alley>
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

On Thu, Feb 10, 2022 at 04:23:15PM +0100, Petr Mladek wrote:
> OK, what about the following change:
> 
>    1. Store only the value (number) in $result
>    2. Add optional --fail parameter

I'm fine with this approach. I agree that it's probably less confusing than
"$2" == "$1". I don't think the elif check I proposed is strictly necessary
either, and in any case the way you've rewired the patch address that.

> 
> Hmm, the 1st step is not needed after several iterations here ;-)
> Anyway, it should be easier to maintain it in the long term when the
> sysctl output might change. We should probably do it in a separate patch.
>
>
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 846c7ed71556..7b624d0fd7c0 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -75,9 +75,25 @@ function set_dynamic_debug() {
>  }
>  
>  function set_ftrace_enabled() {
> -	result=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1 && \
> -		 sysctl kernel.ftrace_enabled 2>&1)
> -	echo "livepatch: $result" > /dev/kmsg
> +	can_fail=0

Can you make this variable a local?

> +	if [[ "$1" == "--fail" ]] ; then
> +		can_fail=1
> +		shift
> +	fi
> +
> +	err=$(sysctl -q kernel.ftrace_enabled="$1" 2>&1)
> +	result=$(sysctl --values kernel.ftrace_enabled)
> +
> +	if [[ "$result" != "$1" ]] ; then
> +		if [[ $can_fail -eq 1 ]] ; then
> +			echo "livepatch: $err" > /dev/kmsg
> +			return
> +		fi
> +
> +		skip "failed to set kernel.ftrace_enabled = $1"
> +	fi
> +
> +	echo "livepatch: kernel.ftrace_enabled = $result" > /dev/kmsg
>  }
>  
>  function cleanup() {
> diff --git a/tools/testing/selftests/livepatch/test-ftrace.sh b/tools/testing/selftests/livepatch/test-ftrace.sh
> index 552e165512f4..825540a5194d 100755
> --- a/tools/testing/selftests/livepatch/test-ftrace.sh
> +++ b/tools/testing/selftests/livepatch/test-ftrace.sh
> @@ -25,7 +25,8 @@ if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]]
>  	die "livepatch kselftest(s) failed"
>  fi
>  
> -set_ftrace_enabled 0
> +# Check that ftrace could not get disabled when a livepatch is enabled
> +set_ftrace_enabled --fail 0
>  if [[ "$(cat /proc/cmdline)" != "$MOD_LIVEPATCH: this has been live patched" ]] ; then
>  	echo -e "FAIL\n\n"
>  	die "livepatch kselftest(s) failed"

Patch looks great otherwise and works fine after testing on my end. Do you
want me to send it out as a v3? Or would you prefer to just apply it as is?
Assuming it's the latter, then:

Reviewed-by: David Vernet <void@manifault.com>

Thanks,
David
