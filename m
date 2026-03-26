Return-Path: <live-patching+bounces-2259-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qNOAJsNFxWkB9AQAu9opvQ
	(envelope-from <live-patching+bounces-2259-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2026 15:42:11 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 39774336F21
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2026 15:42:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 497ED310E295
	for <lists+live-patching@lfdr.de>; Thu, 26 Mar 2026 14:34:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE5135C195;
	Thu, 26 Mar 2026 14:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="N6daZTrL"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5013DA7C9
	for <live-patching@vger.kernel.org>; Thu, 26 Mar 2026 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774535683; cv=none; b=eNOtcDSdQ4CLBAT88r9i09YdPQ1DLImqt4Cd7LFdEW3vF9h2zPSD1t0VGDjgqHSGDnAf3QnNz5cVJPE/OIBwfRfWl1eFyKfXuG7QWaoXOKngbCpl7vk/3Ox6o2kZuBAC/ltKKSh5Rv9auXZgTReDKpvQGHaY8xXAMgPj6uzfvbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774535683; c=relaxed/simple;
	bh=vYwPCMz5MF0nqeEoSiSW+jAW81/Cr9gBV2Z7f920Fg8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FNHCaF1VgE4tbsbuq93P0O2yVa+/YmqBiNPfKXucAkbjFNOzjspdwWNMX3aH8CwCm8TbkexgqzZqUf6ObhyhXXun//L6XzNYCk3QFSiUC+fsUApCYk6aUnIdRbc5au4C46vFb7xfDJYywXurLjVY+NxJBS84FxDl5aXcWeTAbYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=N6daZTrL; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-486b9675d36so10020515e9.0
        for <live-patching@vger.kernel.org>; Thu, 26 Mar 2026 07:34:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774535679; x=1775140479; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fkyYOgkISMsBfkla6FNu12fGRA3gZ1guHAdS0aqclQk=;
        b=N6daZTrLTgnXmdqoUD1VB7eSzjIB9lIYQNr686rPgsV454dfsK8X3xq5Im7ScnGodE
         yhHrthtpF6JUgjUEFPj/XmGbKRPcj6leLn17fL4cYqtdGjdqfNmdP03ePwX/nSvecYuX
         h1qUirc6bHxdC6bSEsSSQU5cLL/xNu/8bKz7mrvTiNXDyCPQA/g4775aNFXuWIhqMpBx
         YmngnQAWUtcI/GbdClWpUI0WWJxFi0/+aRjmRsWBFr3O8hocewSeBM95HMQ0jeRwFIEi
         oykO5dt1vzdsFNeDYnsxuYAV1GmSE4ytb0jGTftyk6gFzE5vPhxS1rkup0lpvjAfpAXi
         z3vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774535679; x=1775140479;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkyYOgkISMsBfkla6FNu12fGRA3gZ1guHAdS0aqclQk=;
        b=qrusMc+U6YJZNBSMUi2DxSJNNLPuyDIphUxSPCuwhEgfrAGzm5OaRehbNWv85H4YYj
         fJRwZm+zE0c0CcXwbKa1jUj8+KorsmwrM3+cO2lYar7lJqXMVaVw46qQ5TzmR9fwjiJ8
         nGkNjsBbh65K4He224dIaxYPm1WE6nkAgUbuKJNgvx6TeE5DJ2ZwV0wHZ+7TgG/V8xRt
         5/2MtuIlnghZCMAOYIl8l/0uc9QA3ixOSZz6Vv+9cOXa4hmuGgVy3ujjs7JGtudEk3E1
         hOiWTFsRpYh6bpPsUIxEnbuEvs5U/wRAIhzxMTvzyeqCHw4cLCDj7/uXhH8V5pMiKtTc
         rOmg==
X-Gm-Message-State: AOJu0YxvutKfFDBBzdwSxaXEWzacPvnwaaDdLDhwlPLBaKgtrql2T3ro
	pxUTLZbsdbApkH2XU73//nhR5PjvyH0v336C8YIp3YInmuWoGOeZGe4+I3j3B4hRAq0=
X-Gm-Gg: ATEYQzwCBhOUJrfA+eiAghbJIoFSgb228LOzGITwE9S8wHVVGoWGom+WigyAOqv3WBD
	HN6Zuz/iXTG3s9mx0fugRQJGp/H8QyTBFFErE1r/O51FlaRDAYYKomibzR6yXfvtZxPWt/eYaNh
	N1EZefREqMuM/QM7IDeOePpy2iymXStXZ2wV+ajMp6j9PyHJ0zDYreA8BlCNdkzM62BSmeD52aj
	OIDMzkn3W9QTezAF6ApgC9Jg+F5Z+NsTgz9kKu+aYNNbysMaOUUoINpwpuFcTXaTPU8kMmaNpp/
	WJkf5Qh4h3ouhSFOFrjsAhR/yGDZ4IVPp0lsARqtC1U/dbXMadQcWkMLs8QULlnML7FQ6vumvDg
	3i0MlJjtEbUkNnQI76s6sAXC1xkNOLTK/M+fLQTMA7LD8DVWb7dXTBtMcFHkZUBfm1Sh1VAiMkk
	C3jimZTNdE8KZ3CcJrvS5h8I1IIQ==
X-Received: by 2002:a05:600c:1d0e:b0:485:3ec6:e634 with SMTP id 5b1f17b1804b1-48715febda2mr116676675e9.15.1774535679105;
        Thu, 26 Mar 2026 07:34:39 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722d23679sm76301365e9.9.2026.03.26.07.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 07:34:38 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:34:36 +0100
From: Petr Mladek <pmladek@suse.com>
To: Pablo Hugen <phugen@redhat.com>
Cc: live-patching@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, jpoimboe@kernel.org, jikos@kernel.org,
	mbenes@suse.cz, joe.lawrence@redhat.com, shuah@kernel.org
Subject: Re: [PATCH] selftests/livepatch: add test for module function
 patching
Message-ID: <acVD_NPu4JVRoaVK@pathway.suse.cz>
References: <20260320201135.1203992-1-phugen@redhat.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320201135.1203992-1-phugen@redhat.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2259-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: 39774336F21
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri 2026-03-20 17:11:17, Pablo Hugen wrote:
> From: Pablo Alessandro Santos Hugen <phugen@redhat.com>
> 
> Add a target module and livepatch pair that verify module function
> patching via a proc entry. Two test cases cover both the
> klp_enable_patch path (target loaded before livepatch) and the
> klp_module_coming path (livepatch loaded before target).

First, thanks for the test.

Second, I am a bit biased because I am working on a patchset which would
obsolete this patch, see
https://lore.kernel.org/all/20250115082431.5550-1-pmladek@suse.com/

That said, I have sent an RFC a year ago. I worked on v1 when time
permitted but it is still not ready. And it might take another
many months or year to finish it.

Your test might be perfectly fine in the meantime. Just see few
notes below.

> --- a/tools/testing/selftests/livepatch/test-livepatch.sh
> +++ b/tools/testing/selftests/livepatch/test-livepatch.sh
> @@ -8,6 +8,8 @@ MOD_LIVEPATCH1=test_klp_livepatch
>  MOD_LIVEPATCH2=test_klp_syscall
>  MOD_LIVEPATCH3=test_klp_callbacks_demo
>  MOD_REPLACE=test_klp_atomic_replace
> +MOD_TARGET=test_klp_mod_target
> +MOD_TARGET_PATCH=test_klp_mod_patch
>  
>  setup_config
>  
> @@ -196,4 +198,102 @@ livepatch: '$MOD_REPLACE': unpatching complete
>  % rmmod $MOD_REPLACE"
>  
>  
> +# - load a target module that provides /proc/test_klp_mod_target with
> +#   original output
> +# - load a livepatch that patches the target module's show function
> +# - verify the proc entry returns livepatched output
> +# - disable and unload the livepatch
> +# - verify the proc entry returns original output again
> +# - unload the target module
> +
> +start_test "module function patching"
> +
> +load_mod $MOD_TARGET
> +
> +if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
> +	echo -e "FAIL\n\n"
> +	die "livepatch kselftest(s) failed"
> +fi

This code is repeated several times. It might be worth creating a
helper function in tools/testing/selftests/livepatch/functions.sh.

> +load_lp $MOD_TARGET_PATCH
> +
> +if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET_PATCH: this has been live patched" ]] ; then
> +	echo -e "FAIL\n\n"
> +	die "livepatch kselftest(s) failed"
> +fi

When I was working on the above mentioned patchset, I realized that
"die" in the middle of the test was not practical because it
did not do any clean up. As a result, "make run_tests"
continued with other tests but they typically failed as well.
And I had to manually remove the test modules to be able to
try "fixed" tests again.

I thought about two solutions:

1. Remember loaded modules and try to remove them in a clean up code.

2. Report the failure into the kernel log but keep the test
   running so that they calls the disable_lp/unload_lp/unload_mod
   functions. The test will do the clean up and will fail
   later in check_result().


While the 1st approach might be easier in the end, I choose
the 2nd approach in my RFC, see below.


> +disable_lp $MOD_TARGET_PATCH
> +unload_lp $MOD_TARGET_PATCH
> +
> +if [[ "$(cat /proc/$MOD_TARGET)" != "$MOD_TARGET: original output" ]] ; then
> +	echo -e "FAIL\n\n"
> +	die "livepatch kselftest(s) failed"
> +fi
> +
> +unload_mod $MOD_TARGET
> +
> +check_result "% insmod test_modules/$MOD_TARGET.ko
> +$MOD_TARGET: test_klp_mod_target_init
> +% insmod test_modules/$MOD_TARGET_PATCH.ko

Note that the existing helper functions log the userspace commands
in the kernel log. It helps to understand the kernel logs.

In my RFC, I created a helper module which implemented a person
(speaker) which would come on the stage and welcome the audience.
I am not sure if it was a good idea. But it became a bit confusing
when everything (module name, sysfs interface, function name, message)
included the same strings like (livepatch, callback, shadow_var).

Anyway, my tests produced messages like these:

+% cat $SYSFS_MODULE_DIR/$MOD_TARGET/parameters/welcome
+$MOD_TARGET: speaker_welcome: Hello, World!

, see https://lore.kernel.org/all/20250115082431.5550-9-pmladek@suse.com/


There were even tests which blocked the transition. They tested shadow
variables which added an applause to the message. They did something like:

<paste>
All four callbacks are used as follows:

  + pre_patch() allocates a shadow variable with a string and fills
		it with "[]".
  + post_patch() fills the string with "[APPLAUSE]".
  + pre_unpatch() reverts the string back to "[]".
  + post_unpatch() releases the shadow variable.

The welcome message printed by the livepatched function allows us to
distinguish between the transition and the completed transition.
Specifically, the speaker's welcome message appears as:

  + Not patched system:		 "Hello, World!"
  + Transition (unpatched task): "[] Hello, World!"
  + Transition (patched task):	 "[] Ladies and gentlemen, ..."
  + Patched system:		 "[APPLAUSE] Ladies and gentlemen, ..."
</paste>

, see https://lore.kernel.org/all/20250115082431.5550-11-pmladek@suse.com/

Sigh, I have done many changes in the tests for v1. But they still
need some love (and rebasing) for sending.

> +livepatch: enabling patch '$MOD_TARGET_PATCH'
> +livepatch: '$MOD_TARGET_PATCH': initializing patching transition
> +livepatch: '$MOD_TARGET_PATCH': starting patching transition
> +livepatch: '$MOD_TARGET_PATCH': completing patching transition
> +livepatch: '$MOD_TARGET_PATCH': patching complete
> +% echo 0 > $SYSFS_KLP_DIR/$MOD_TARGET_PATCH/enabled
> +livepatch: '$MOD_TARGET_PATCH': initializing unpatching transition
> +livepatch: '$MOD_TARGET_PATCH': starting unpatching transition
> +livepatch: '$MOD_TARGET_PATCH': completing unpatching transition
> +livepatch: '$MOD_TARGET_PATCH': unpatching complete
> +% rmmod $MOD_TARGET_PATCH
> +% rmmod $MOD_TARGET
> +$MOD_TARGET: test_klp_mod_target_exit"

Summary:

IMHO, this patch is perfectly fine as is if we accept that it will get
eventually obsoleted by my patchset (hopefully in a year or two).

On the other hand, this patch would deserve some clean up,
(helper functions, don't die in the middle of the test) if
you planned to work on more tests. It would help to maintain
the tests.

Best Regards,
Petr

