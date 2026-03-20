Return-Path: <live-patching+bounces-2247-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kLCcGDxMvWlr8gIAu9opvQ
	(envelope-from <live-patching+bounces-2247-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:31:40 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD6882DB02D
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 14:31:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 73E67306B5A5
	for <lists+live-patching@lfdr.de>; Fri, 20 Mar 2026 13:26:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9303B2FDA;
	Fri, 20 Mar 2026 13:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FPFpdd/+"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C4C9377036
	for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 13:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774013169; cv=none; b=e+QN3X+hnkbRxyezpmSAfwkJ+26CKRUVp4dfni26EQ1WNVMQ4ZhZ5W+1MqpCBMP7mJVw3rSEzn1nfgB8n4fBE9F7zo7o3iob8ztcMuz/ltx8wiF/ruJ/BZS2FVeVs0KjIIED1dE/iD2c33iCDuw0Wm/kc9TCTj3R9jC15Ky6ZJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774013169; c=relaxed/simple;
	bh=WPvpeQDdzO+GgprJ21xMbMraGpIYDJe/5WMU9LWDYn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hrzYQ4d0eKi1XysR3Oha0dNLH1CZdEmZYECLtALwIMA38ly9Utt4eWA8CFdnpVSgS2pxXTKe5q/kvk64H9m+AwDXYuOdBe637zm44VogWd95BrQ9EvSGrz4st6fEaV3wRPisW7JzdcjHfbHHvrFvTI6aD2Zoa038d3z5kZ2OhAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FPFpdd/+; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-439d8df7620so1265248f8f.0
        for <live-patching@vger.kernel.org>; Fri, 20 Mar 2026 06:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774013165; x=1774617965; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YleuovkqL/mLOY7qyM/w1oS9wpwrcConR5IRWNylFhM=;
        b=FPFpdd/+24PtKRKI+GEuYmgHqugZXgdZj8in0BMxRq9Dg5V3MIeDhNvZcETrEYCjuu
         RVlcV7xZ5ICC743alKJGXL/dCwAGV8iuLF21E6tlBwJO4MH3rP5fFhXikvdQj2ubenzd
         Nc9230xIFC+ihGXMpNvdassrr6ESj13BadreNV0JGAGx1Te6BDlrFnwRVdW1mp+x0ZEE
         zyZ0x79WTOijhlDFENOJtt/Ui7xCvrezI1p9i1LOFvCEb+jupqKvREcNIeCGKW57fCj7
         cXigUyqi/aDl5tw3pcY4A/pWj+Yub6C9B/K2Dhd6tNG34BCOWzfHXSCVHWoxi+tLpb7c
         eZFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774013165; x=1774617965;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YleuovkqL/mLOY7qyM/w1oS9wpwrcConR5IRWNylFhM=;
        b=Wf1RRazK07vBHueovZwgfdplQtiANw9U+8ClTHdPSCXoJ1hmV3+LVt2lCbKVJFxKw4
         VbHzqS2BSzYxOTkQxoOQyQlhj9LdbXpcDsFQGvXwqkEMwgFsYKxbSgLOVUF5Yf79csgM
         UBUmcUa5F4EQwc/ftoz4rRsyg+/51T4NMbnJhzXrx3b5GwkJv73WiHnLPTs7W00DZjOg
         EEcHgeYzvE/RRw2IflvCq/uuqYlRA6GxnBMzAUWN5Tf3/l7iCPvVeOa1frkXA+vnuJpS
         VXETDTXhBBrfVPvhaOjM0RpJFbbZxNdLBgbyZ7pKKB+4EUxn+mZAe5+bp3q8UIFBApbq
         aKcA==
X-Forwarded-Encrypted: i=1; AJvYcCXQsnU6qvFv+/FNmjPi/92AoiUZsSoxET7zqZ4nRKLMfEUHAs07e/tN3HV0Yo7CBOlXGyK7XOo6D5wxiXKU@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh7UHPT4JVmrPwC2889lJBMMjqNLM4zhwzSS9ll7pfPx2pjbP8
	VSse62OLdNSwTx1pyaFIAL8gUWcDJ0ReEP+DOl7rf7lZPt7VBtkbDghVM7Z2eYMieKM=
X-Gm-Gg: ATEYQzwVFQR4WaYtnNVGHGJQzWH2xC+jh/aqznP8Hp7p5oLql0pJqv4SRFLAN36yhYn
	wDfg0ys59HVUpT5JGJK4vm8KIfSFrH1lTn6+JCTO70q88+xe4ZIBeogzKR0OXdnD1kLVE2fC3gY
	3MdPaMC/o0vpBN3ABN1UtJjH7wm+Ge6sRDhor//9BL2iNsOEOXVGBSFcdweAlWSUHvPySevfMP9
	llvUWHIJMB23CXrzc1R9p4jbpWs8uAKVACWGXBmrS6Z57/1a+ePYop7NSJQKpyq9/LT0OH7WYZ8
	57zN/R/CMwoFH9Craj12Ee3+hxv0Wjpz2+JB+f/euPPQQRvJZJ1c8Wmnef6Z4fy6fKq8SXGRjDz
	EEuKz5JqbE4GLC37EEoHgWlNKWpOSuolP5ISr/T2FYPNnRde7Jut38gThfn10/Wf9kAXBOwknb7
	MIOsNn7DbIH7+N7I6G/cfI0HQnNQ==
X-Received: by 2002:a05:6000:2f84:b0:43b:464a:28de with SMTP id ffacd0b85a97d-43b64243b0dmr4968964f8f.14.1774013164909;
        Fri, 20 Mar 2026 06:26:04 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b6471a297sm6548523f8f.37.2026.03.20.06.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 06:26:04 -0700 (PDT)
Date: Fri, 20 Mar 2026 14:26:02 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/8] selftests: livepatch: functions.sh: Extend check for
 taint flag kernel message
Message-ID: <ab1K6oR06sLm9LM_@pathway.suse.cz>
References: <20260313-lp-tests-old-fixes-v1-0-71ac6dfb3253@suse.com>
 <20260313-lp-tests-old-fixes-v1-8-71ac6dfb3253@suse.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260313-lp-tests-old-fixes-v1-8-71ac6dfb3253@suse.com>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2247-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:dkim,suse.com:email,pathway.suse.cz:mid]
X-Rspamd-Queue-Id: CD6882DB02D
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Fri 2026-03-13 17:58:39, Marcos Paulo de Souza wrote:
> On SLE kernels there is a warning when a livepatch is disabled:
>   livepatch: attempt to disable live patch test_klp_livepatch, setting
>   NO_SUPPORT taint flag
> 
> Extend lightly the detection of messages when a livepatch is disabled
> to cover this case as well.
> 
> Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> ---
>  tools/testing/selftests/livepatch/functions.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/livepatch/functions.sh b/tools/testing/selftests/livepatch/functions.sh
> index 781346d6e94e0..73a1d4e6acaeb 100644
> --- a/tools/testing/selftests/livepatch/functions.sh
> +++ b/tools/testing/selftests/livepatch/functions.sh
> @@ -324,7 +324,7 @@ function check_result {
>  	# - filter out dmesg timestamp prefixes
>  	result=$(dmesg | awk -v last_dmesg="$LAST_DMESG" 'p; $0 == last_dmesg { p=1 }' | \
>  		 grep -e 'livepatch:' -e 'test_klp' | \
> -		 grep -v '\(tainting\|taints\) kernel' | \
> +		 grep -v '\(tainting\|taints\|taint\) \(kernel\|flag\)' | \
>  		 sed 's/^\[[ 0-9.]*\] //' | \
>  		 sed 's/^\[[ ]*[CT][0-9]*\] //')

With the upstream maintainer hat on:

I am afraid that we could not take this. It is needed only because
of another out-of-tree patch. It does not describe the upstream
behavior. It might even hide problems.

We should maintain a SUSE-specific patch against the selftests
as a counter-part for the patch adding the tainting.

Or we could try to upstream the patch which adds the tainting.
Well, we might want to limit the tainting only to livepatches
with callbacks or shadow variables. IMHO, only these features
are source of potential problems.

Best Rerards,
Petr

