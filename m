Return-Path: <live-patching+bounces-1001-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFFD1A135D5
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 09:49:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EA9DC7A146C
	for <lists+live-patching@lfdr.de>; Thu, 16 Jan 2025 08:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F586156C5E;
	Thu, 16 Jan 2025 08:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="I5YQOSj3"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3C735944
	for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 08:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737017338; cv=none; b=K/dFgYJnmMYoapxxOBaSOWTFW3Jxjb5nclbyQI3R4ofUBL20qPrej6QU5bHBejsX/enE77I+TpE+LJzv9QyIx9l1bakK3wktvj9hGlIsud0qlKjuo4bdp65v8FwUl6iOhlkuh3fUMF98lQO8gHsv9vOd5i5hfBlGav02F2wDdyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737017338; c=relaxed/simple;
	bh=oJaiN76uPfiXkExaF7tWA3VGpAzcOC3Q1zWL6iuj59I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uC16mbtG9qSHJU2MPYCT7Ll3WTg7CSIFSGBaLvlkXqQdaNeTmpb2OMB8QxVFWYMyBbLcXdApfdge63iAhFgt9D6TWa8vgYEavKJVB2ocgnAmXIAx5YaPgww+AnQb+vNIR2CxjafOWbhin75jGoqxNfOnT7gg16TOM4l8pXXtttA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=I5YQOSj3; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-385de59c1a0so383939f8f.2
        for <live-patching@vger.kernel.org>; Thu, 16 Jan 2025 00:48:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1737017334; x=1737622134; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=85Hem5/4iiRrxcllFoKkxID9Ic1JngXWE6kd2xDlJ1M=;
        b=I5YQOSj3iPZDh8hbDISiOwLAa07RY2QAFWeCgRqlZeKoTKg92zlwGXnJxotaQ2ZK6K
         wVw1ecHOrZExAFlGMMDzKjlPm83BNqBd1KzbqUyo3J1WNRlC2fLIeabk3YFle5b31ptY
         tY9jjHLgeaEIhwfSUoHPLOUUnk+Xv+ah8QlgzwHV2iW19ack+VC3ml2LjdT913aUCrJT
         cz6hu59+ZDHhdB7aRDUgQA0YrmS3g02NvYcj0e3qzN+1k1dA+CWigwJaIuGXQHx6U0rQ
         0akpml0esAc4jAUABXrTIZOKnSdCKfXPzu6N5LwM/S/4mE/h+8QaQthAJH4gs89VJ+Og
         WZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737017334; x=1737622134;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=85Hem5/4iiRrxcllFoKkxID9Ic1JngXWE6kd2xDlJ1M=;
        b=nykl6ZQJGp51Q/FUgBCZeioBMXLfyCvZ32hIND4UeSv9w45Fh6qW0eAv9/2qL6/t3v
         qYnD9OkiCI8m0QvQa7eaJJFqvTc2n/t3gYEh4Aqi9QZRmyOC7vj2XoOESYCW2feMWq6E
         F8d6oVPfQYHKNCjuL3JsLsMc7/gk06ZfvLmh6ZSX9b2uzdUuJRPpUUlYSMZVuwF7SEVU
         /Rf0xYf2z/5RlpvrThyNd1dYKP9jerPqc2NLpnP60BF93zXr+1cXxOAxh8pYiIoJxKkn
         rH/osBFpWagTPkH/dOVxJL0W4G34A/bOyhkvpDP6LNAg5uo2CTS9KzJD2nD0B3xCWAKq
         nuYg==
X-Forwarded-Encrypted: i=1; AJvYcCVcoW4IvYKMHVkD4FjwUbbTkWwETxW9ew6i/SlVC4zvrLtMLqZwDc83PJfwLgk2fDUr4eRjhnaFdftxA6a5@vger.kernel.org
X-Gm-Message-State: AOJu0YypskdgBbdzs5EdWDR//jjiBbSV3rS8/og+N0GsOtrZGFfKuY4f
	5uNib9wFWONXDrrgIxWn7+DZysXzOTc05rkvkSWQcU491mKBgAdsF5grHbAsTk/D+12T91bdD5z
	r
X-Gm-Gg: ASbGncvdajP8q1Gq1ieLrsCqPJALc47KlknciBeSi4QSKgwFw48xK5Zvmpg2+pj5mkg
	geDIlIfBHblv6aGO9lugw9CbRLmlZeWOerBNqdRlKro+a/wCnLQGU96QDamolphHg/2mi/UOf8H
	DAdoLTvMHChS8RQtQninXZn7UPxKiPac1zeOFTvMqg4NpNeun5E2CWR3ukaLaDCGD8Ge6dSLa0J
	D6Vh+33nUMgM3E6XlOGnCQA6oUAB39tEciucZJh8ch+MobnZ1kOBGaNNA==
X-Google-Smtp-Source: AGHT+IFM6ix0zgTZCNHyMnUKfcHtbEqHlaPBXl9LZTitAHaqwQBPn2oJAN25GNK/ZqXu94tMPoU2Eg==
X-Received: by 2002:a05:6000:4b0a:b0:385:fae2:f443 with SMTP id ffacd0b85a97d-38a87313975mr28739259f8f.34.1737017334496;
        Thu, 16 Jan 2025 00:48:54 -0800 (PST)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-437c74d886csm51384905e9.28.2025.01.16.00.48.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 00:48:54 -0800 (PST)
Date: Thu, 16 Jan 2025 09:48:52 +0100
From: Petr Mladek <pmladek@suse.com>
To: laokz <laokz@foxmail.com>
Cc: Josh Poimboeuf <jpoimboe@kernel.org>, Jiri Kosina <jikos@kernel.org>,
	Miroslav Benes <mbenes@suse.cz>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	"live-patching@vger.kernel.org" <live-patching@vger.kernel.org>
Subject: Re: selftests/livepatch: question about dmesg "signaling remaining
 tasks"
Message-ID: <Z4jH9By-NdPCKM8f@pathway.suse.cz>
References: <TYZPR01MB6878934C04B458FA6FEE011CA6192@TYZPR01MB6878.apcprd01.prod.exchangelabs.com>
 <tencent_D03A5C20BC0603E8D2F936D37C97FAE62607@qq.com>
 <Z4fa0qCWsef0B_ze@pathway.suse.cz>
 <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_FB39E787D4AB347DE10AE0811A00946EB40A@qq.com>

On Thu 2025-01-16 13:03:16, laokz wrote:
> Hi Petr,
> 
> Thanks for the quick reply.
> 
> On 1/15/2025 11:57 PM, Petr Mladek wrote:
> > On Wed 2025-01-15 08:32:12, laokz@foxmail.com wrote:
> > > When do livepatch transition, kernel call klp_try_complete_transition() which in-turn might call klp_send_signals(). klp_send_signal() has the code:
> > > 
> > >          if (klp_signals_cnt == SIGNALS_TIMEOUT)
> > >                  pr_notice("signaling remaining tasks\n");
> > > 
> > > Do we need to match or filter out this message when check_result?
> > > And here klp_signals_cnt MUST EQUAL to SIGNALS_TIMEOUT, right?
> 
> Oops, I misunderstood the 2nd question: (klp_signals_cnt % SIGNALS_TIMEOUT
> == 0) not always mean equal.
> 
> > Good question. Have you seen this message when running the selftests, please?
> > 
> > I wonder which test could trigger it. I do not recall any test
> > livepatch where the transition might get blocked for too long.
> > 
> > There is the self test with a blocked transition ("busy target
> > module") but the waiting is stopped much earlier there.
> > 
> > The message probably might get printed when the selftests are
> > called on a huge and very busy system. But then we might get
> > into troubles also with other timeouts. So it would be nice
> > to know more details about when this happens.
> 
> We're trying to port livepatch to RISC-V. In my qemu virt VM in a cloud
> environment, all tests passed except test-syscall.sh. Mostly it complained
> the missed dmesg "signaling remaining tasks". I want to confirm from your
> experts that in theory the failure is expected, or if we could filter out
> this potential dmesg completely.

The test-syscall.sh test spawns many processes which are calling the
SYS_getpid syscall in a busy loop. I could imagine that it might
cause problems when the virt VM emulates much more virtual CPUs than
the assigned real CPUs. It might be even worse when the RISC-V
processor is just emulated on another architecture.

Anyway, we have already limited the max number of processes because
they overflow the default log buffer size, see the commit
46edf5d7aed54380 ("selftests/livepatch: define max test-syscall
processes").

Does it help to reduce the MAXPROC limit from 128 to 64, 32, or 16?
IMHO, even 16 processes are good enough. We do not need to waste
that many resources by QA.

You might also review the setup of your VM and reduce the number
of emulated CPUs. If the VM is not able to reasonably handle
high load than it might show false positives in many tests.

If nothing helps, fell free to send a patch for filtering the
"signaling remaining tasks" message. IMHO, it is perfectly fine
to hide this message. Just extend the already existing filter in
the "check_result" function.

Best Regards,
Petr

