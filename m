Return-Path: <live-patching+bounces-754-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 14D8F9ACBBF
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 15:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C01781F220F1
	for <lists+live-patching@lfdr.de>; Wed, 23 Oct 2024 13:55:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 168BF1ABECF;
	Wed, 23 Oct 2024 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KyX2Cz0Z"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90831A7264;
	Wed, 23 Oct 2024 13:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729691744; cv=none; b=ONYlJWPCSz5A0Kgs0kOV+vrJEb0HZ8q1eSn70xYhxKStxxz6+YYrd5K8+BuxZHVxCyLW2siwjoqvSd5BxibZESmAwtHSFJCD1YDTNwJBF19VPEGlHwQnKztnCu8DETLwko37m1NUyE1REf03JQBOGthDxELAb4pg4Stkigc+yiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729691744; c=relaxed/simple;
	bh=DaS/TnXxKUc6HjMCIGd2U5rLKVmcwNq2jWsJ5Z7TkVc=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=p6M3Xrpv5XagBlGedOFWyg0idI3SltG/mxyoyTjQoWR9WEbyLEE7L5fw3BMAg61MX0C2iltzKrkor7L/SL5noptkmXnNC8vxu2FD2iiJsDz0XS3shd5Z957qtbuAacPZbLI/jy/1aSipPaEvQWd/pOvwJi3Q53FMCi3n+IGpPOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KyX2Cz0Z; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e34a089cd3so5558136a91.3;
        Wed, 23 Oct 2024 06:55:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729691742; x=1730296542; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q/1eAoSFUi88G9yBoAUjeJHtlikszBn/3aVYB3y+C8I=;
        b=KyX2Cz0Z7eXdadm1JOiqyLhuR3ZgJfurQCn/VsaNUjJGRXp/8ajhN5cql+nVNrjdsI
         JxNRGxylL5s3zgzj0fsW+vaAlPX9OWKB3Ov+LLF2EonvPHhcT1GmzyTev8c0Rd6EpZB5
         YRGc2CLBPDB2GFbD0Q4BIEeUvKTxBp4vcUUioewnA+rT48rPx7YxRFaJASsbOW4lih48
         i897Ur2PffiwwOH+AP+JFuzH6DIdZXoHR7FsainprcEyeLuh5zJjydn7S3FJj5Z0xGb7
         0yhdp1FTfdEWQk5AhtqjbNSNcxZ7DOW8wsJVseUu7fMi538Zwx9GzDDpZ4thnYMoHajW
         HiEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729691742; x=1730296542;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q/1eAoSFUi88G9yBoAUjeJHtlikszBn/3aVYB3y+C8I=;
        b=vImQ7CV2XNxCcUjCXhiR1SUYNDVhjDkqVupkSdD3ZMP8mfvzYP3F47TcDGiCI8FOHY
         1B0Wj72jOYebIMXh1cEGYKW0Rcjy5Dwo9DfFshEQPA3p+/SBnvayL7w7Ey3LKdT9IbyH
         141shYQ4Jb0/A4B8oAmzdn4DBHmeHkKoD4gHOWb4iY3117/fmiWAy5jRoMQw6w6Pg0lm
         xwgRcH3S5eqJTq+5Rf1V/xWp/xK3niODFqmGJGB5UJ6O9l4+uBXDlgASu5HyGL0LHKx/
         OQ7dlanlYRAWshZdhFf16uYuypNvmNUkjR/d8tS2bDOyWlbYXpImxfBiVnFF/dNuTvBn
         eQoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMbimQc7VpBvy9sPA8DYkZEy6a/ytF7AxjcmeKbW9aXD+Fl13EQEH+5uJ8e3C2fTZ1R4lRRSDOvKF7bZY=@vger.kernel.org, AJvYcCXQXDM2v694gEqO1ENQjg2lNv8/txv3tyNpdpel1mK8vlthcdBATqnBdGg1yzhI79q/wrCWOnJ1P1b/M1RQVg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxZM478tOeL3Iliok/1hqhfQJlC2wGegp7XwhmE04EU051QoXWo
	C5p945Xg+EDOacDU18vRKPBGip0VEhqVMSkSj6qdoenGmQIhCBoT
X-Google-Smtp-Source: AGHT+IGVvk5WyzHaifpVdeL22petjloJfnRcC8R+gbZ6y/Oqp5dvrRVC2JduDmXr0yv0cJ9BVoEbmg==
X-Received: by 2002:a17:90a:e396:b0:2e2:f04d:9f0c with SMTP id 98e67ed59e1d1-2e76b5dbc24mr2976601a91.13.1729691742066;
        Wed, 23 Oct 2024 06:55:42 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e76df50b04sm1428055a91.17.2024.10.23.06.55.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Oct 2024 06:55:41 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] selftests: livepatch: add test cases of stack_order sysfs
 interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZxjuNBidriSwWw8L@pathway.suse.cz>
Date: Wed, 23 Oct 2024 21:55:27 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <41DE05F9-9944-4BB0-8C17-5FE8939F9511@gmail.com>
References: <20241011151151.67869-1-zhangwarden@gmail.com>
 <20241011151151.67869-2-zhangwarden@gmail.com>
 <ZxjuNBidriSwWw8L@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


What's more, I have open a pull request of the user space tool kpatch[1] 
to use this new kernel sysfs attribute 'stack_order'.

Maintainers who feel interesting in this function can come for a look.

Best Regards.
Wardenjohn.

[1]: https://github.com/dynup/kpatch/pull/1419

