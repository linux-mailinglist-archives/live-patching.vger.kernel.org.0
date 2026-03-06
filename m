Return-Path: <live-patching+bounces-2150-lists+live-patching=lfdr.de@vger.kernel.org>
Delivered-To: lists+live-patching@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ALpMA8Hpqmm8YAEAu9opvQ
	(envelope-from <live-patching+bounces-2150-lists+live-patching=lfdr.de@vger.kernel.org>)
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 15:50:41 +0100
X-Original-To: lists+live-patching@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0639722313E
	for <lists+live-patching@lfdr.de>; Fri, 06 Mar 2026 15:50:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CB559308E05A
	for <lists+live-patching@lfdr.de>; Fri,  6 Mar 2026 14:41:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142AD33B960;
	Fri,  6 Mar 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MCyZiSkf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0C682248A5
	for <live-patching@vger.kernel.org>; Fri,  6 Mar 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772807902; cv=none; b=qUKD+T3LM20PUSntO0wm6KBXNdlc3H1MBW/bVhR4g74o8hXiFvD22dhHaaWoGZLr5tf+rCCQsb02UhsRwO1iPLf8Rb9LKzDDpQOhh0ZMSYu3QFEyQkVDvPhu9yFCMDu67vJk9WhU7zBhrY4jifsLSp1sCMD9dqaHn/3MaQwuS7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772807902; c=relaxed/simple;
	bh=vy9qDHQE9TnWOPW1buR+83iNmNCigIukqJRH8YmZRoQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oiKkrBvSO6VkvWOuSBiRDq2IJ4qctxYn9fzSHD03uTa2WbNZ9fW7DVcOgfkK4T7PTfV3bJCM/6ZI8MRTEPRu2NG1CRq5rsWrUQ1U2xGGBOv+fnDNkZQlMqS0l6sV14B7rD3IBqunCT4TRyH+LMJ/7H5uFE9zblKUYFj/LOBB6a0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MCyZiSkf; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-439b8a3f2bcso4458439f8f.3
        for <live-patching@vger.kernel.org>; Fri, 06 Mar 2026 06:38:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772807899; x=1773412699; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VN+ccTSTkmIhecLGiyEENku0saMX3lI6yYuM887yi+c=;
        b=MCyZiSkfmeTkS4fR0sngY7+Qgm3Up3XKnqP6vvxYh0vSasvNA8+gpJ005v9/nnQW2D
         ey89bKLd7BydqFkRvaSo2ZEe4URk1vzPWdlXGYtQ89Xh0MxEX8Fcojk3M1Uz5f0gnAMW
         F2Ebx0Qe2fYeMphApjTANLcpkOexUT2nQiahUCeF/e5Cg5quEOoRi+UDO6TJZXmA/fie
         2dnO0IvDBWaScikT5fTR+JxnatwVlq+8+lCqRB8YY2RglmMSe6cA8kYjKG5hyzat66KU
         mge2BkFI/tWRqel8/qO/elMvLYH2zAcYcw9EiexMI0eRTNkmmbdty/FR/nhTY3KlEZGM
         i9pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772807899; x=1773412699;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VN+ccTSTkmIhecLGiyEENku0saMX3lI6yYuM887yi+c=;
        b=s3Fslw88KdMQeIsF+gYl9fgE/YeX5tRlqdGyuqTZfosvJ2mE9jEvDw4BdVKAnofQLs
         SZREamwdzRvoz1m+Hz0mWyEGdjiGYIJaYFA9gTeDF2irOLp4h9esXvcDQDE+1W7IAjOh
         NQODUaEXSn9nOciqIHXhZodLLdc5maHUhxHa5Eup1s36wJzvJ84Xdf3/rAftRRoQld6N
         ZktT+8Wrokj5NFIUzL1qzQLc+GjYiar4L88jxhtleCfkSjiJycW85m+0HXBu9DiT/TfG
         rb1t0idzBMNWtmt8uhYiDTH0rbzUmS3WHMnTo5ov1DvT3ARLAEIh3ezf3nkhbWi1amfI
         jgtw==
X-Forwarded-Encrypted: i=1; AJvYcCUoZY8wOkemJ0OxwK0h0LpoPnP2PhzzDVyYMlkbczb7cGhO9zHGln6x+F+zSav49vh+k+MWH8uSWM4RlqDI@vger.kernel.org
X-Gm-Message-State: AOJu0YwvYEtCZr16wBLoutKg6fIRk8sMf3EJHhBrqUlYrebNdVeXyWPR
	m+R1Y6quAd0qyWcghoHm2wCs+v2ScNrydadd2FS4bIwXnucCdX7crmthRsDEfNQDhFQ=
X-Gm-Gg: ATEYQzxrqqqSXyBT/ALrxPCHJwFT/iYbxH/7SjH0WamHaojJdjUpt3lz42co2fq3Ybj
	qiX14Rb1OAw4TLfJqzrfISb0XWISDLuDbXCc7je/2BqBw+F+iBrVA7/l+UfHiWJzX0HAkeMrI4F
	eZjAfiy1cRtntqj89vUG+8Ce3Yg+81G1hS3BEOlqT5dDbszAems2zDGvRuklr4KZbJU14i3FQbf
	3ip1HWq3y8or63x1PpMLQ147zIQlKgF0AqJ1ZUv9C0YVrfp20OhIzoP0KeR63LyzOMyhNP6PAjK
	P5ptF+CuPSHVAVfqXCo9TxOcrTvg4zhlCC97O2WqIjb85EmrwqIn6xjnH5aJdOtRFR3uV7/zHo8
	whL6THHizur5V7g0Jxp1A/EhI53DMOiq/vefRes30yUPtCBw4MZRvtPFW6KNza3FzNHp/UVO4ri
	xN0Vg4wH5o9PlVMJ5DwVwJIr0DFw==
X-Received: by 2002:a05:6000:4313:b0:439:a95b:3c43 with SMTP id ffacd0b85a97d-439da65e31amr4194449f8f.21.1772807898957;
        Fri, 06 Mar 2026 06:38:18 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439dad8dbb3sm3821241f8f.4.2026.03.06.06.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Mar 2026 06:38:18 -0800 (PST)
Date: Fri, 6 Mar 2026 15:38:16 +0100
From: Petr Mladek <pmladek@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	Shuah Khan <shuah@kernel.org>, live-patching@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] selftests: livepatch: functions.sh: Workaround
 heredoc on older bash
Message-ID: <aarm2KYH3ZsPnuJN@pathway.suse.cz>
References: <20260220-lp-test-trace-v1-0-4b6703cd01a6@suse.com>
 <20260220-lp-test-trace-v1-2-4b6703cd01a6@suse.com>
 <aark_LapcGkPjrLu@pathway.suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aark_LapcGkPjrLu@pathway.suse.cz>
X-Rspamd-Queue-Id: 0639722313E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[suse.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-2150-lists,live-patching=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pmladek@suse.com,live-patching@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[live-patching];
	RCPT_COUNT_SEVEN(0.00)[9];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[pathway.suse.cz:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo,suse.com:dkim,suse.com:email]
X-Rspamd-Action: no action

On Fri 2026-03-06 15:30:20, Petr Mladek wrote:
> On Fri 2026-02-20 11:12:34, Marcos Paulo de Souza wrote:
> > When running current selftests on older distributions like SLE12-SP5 that
> > contains an older bash trips over heredoc. Convert it to plain echo
> > calls, which ends up with the same result.
> > 
> > Signed-off-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> 
> JFYI, the patch has been committed into livepatch.git,
> branch for-7.1/ftrace-test.
> 
> I have fixed the typo reported by Joe, see
> https://git.kernel.org/pub/scm/linux/kernel/git/livepatching/livepatching.git/commit/?h=for-7.1/ftrace-test&id=920e5001f4beb38685d5b8cac061cb1d2760eeab

Grr, the above was meant for the 1st patch.
This 2nd patch was _not_ committed.

Best Regards,
Petr

