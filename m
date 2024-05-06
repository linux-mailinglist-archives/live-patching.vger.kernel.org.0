Return-Path: <live-patching+bounces-236-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C5B3C8BC5AB
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 04:04:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E171C1C21159
	for <lists+live-patching@lfdr.de>; Mon,  6 May 2024 02:04:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E997B3D55D;
	Mon,  6 May 2024 02:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ksRTZJ2Q"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894772B9B8;
	Mon,  6 May 2024 02:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714961083; cv=none; b=qt5LTM9RkpZm2I7jehdSG5VSj3XxlrxiWM7JOKYJFY2CPJ0K/kcewogIalL8FE9jFMhRsJFv0zQLUjAb4bZmG8s3GYxiTPcl0/FMCSnsOCUWxpTThJ5K/3AT/IdMjCwv1y/copfpm5bpv1ilzTtc3qpHtTCz0JfdfLkNIOu8Zk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714961083; c=relaxed/simple;
	bh=hz/ca+J7Z712p1cKM6pciDLp5eHxR4wl9tG8AiSMRQk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=sU3eLFdzA/i7ja3G++VHXE3M3k6HScbtJeFBwPjWpMphpnVho9g/MEKUM2WYk98OmwA/KEyxbRVkOUzVFyFjS07leEp5wUYHzjy2CKf52suZGW5Q1mD3BYpAcaVFE262qL0dN/FgisLpFzpOiGduMXdm79nF72+HO4LNEQWKfDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ksRTZJ2Q; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6f44e3fd382so916338b3a.1;
        Sun, 05 May 2024 19:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714961082; x=1715565882; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exY2+EBV7rKKf5A+MApdskgDLqNqkvJogkXu9c2BhNg=;
        b=ksRTZJ2Q87Cpid2GnaB7yjEWLFRf2BAQRwLi/Jk6a3CRmtTJq4b5bJJOOClx0BaXwh
         cBBrNB+RsEAkIUfDz2Ww67eAMX4Huj73gZUxXs3CwrfAdj4pFdEEDKS8EGoRGxQVg5Ag
         WQT9O+xDb7MJR/jpwcDyPBp0z9/pAMExqXhtkZwjj28VZc/2ySvk8hr5H65UAPEIPIta
         Kqsyl7PpnN7dkDrn4sKj9k1/IXzMm31mrq5+2nwBzUsdeJXDgtIIlmv+wvoAeKw++MPr
         DDBBQw6H5Iz7cPRDUF6ipDy+FgDlry1e2yD33Mv1jDvWFVh86d613UQED9J29sV7wKzc
         tQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714961082; x=1715565882;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=exY2+EBV7rKKf5A+MApdskgDLqNqkvJogkXu9c2BhNg=;
        b=RsFtUt+alcEtVJzvKF6Ft0OMAyJop6lwR/f/OCWOosdhkTkycSKOI+dgIOOb1E6evQ
         fDVIOu8JOPPknpVj1CQtKmXclOy8ztpq1JlWx3n72D0yVhuwdPprtb6e7uH2yQfcO2EX
         /Bzlk5KNtfcoWOfTu8Yz4LtDoHTVq5mfFskBap/U+ZnP1U1B0dCsVoeakIwAwS53XWOm
         /K8EZz/kOn+pMg7RGUE21ALKgRCIT9w7XtrDaiTfDXSlLP7S+GsnB+s8iFNO7Sw2rsj2
         Z02BncyX1CrQG0ivahVmnSUk4S7NCgJjb9ELEP41Guo5qtGyeLcOia/RcTcDceRyDlEu
         tgtQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdJYCEtDIRPKdnuSw84XNYbk5wPnUkaS5w06TibaynDzbvuD/BwyGtf7fejfUDbor3rLSlpyMz56etl4tNUpTXvWGb2VIQt9IBT6qPM3twO/YbL/zLga94qN9VK6uE01ojtTW+z+t8s+UdIA==
X-Gm-Message-State: AOJu0Yxi84Gt00EL01tKG2qwPqV2U4/q62+BoK5P26SeX1plqKXysRAV
	g8JBB8w90KjRJUvNZM6QVX9OyaP4tRFWlibC/NF3QEe87R+JuuxT
X-Google-Smtp-Source: AGHT+IG89GNsVrSalrxzsYt26dJYJsXqqmBTBR9MdsqS3zsKZGgUj0rqCQmgoy74vTqU686x8gb4MQ==
X-Received: by 2002:a05:6a00:464e:b0:6f3:f963:505f with SMTP id kp14-20020a056a00464e00b006f3f963505fmr10001211pfb.5.1714961081797;
        Sun, 05 May 2024 19:04:41 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id w17-20020a639351000000b0061cf79eab38sm5162651pgm.37.2024.05.05.19.04.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2024 19:04:41 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.500.231\))
Subject: Re: [PATCH] livepatch.h: Add comment to klp transition state
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240505210024.2veie34wkbwkqggl@treble>
Date: Mon, 6 May 2024 10:04:26 +0800
Cc: mbenes@suse.cz,
 jikos@kernel.org,
 pmladek@suse.com,
 joe.lawrence@redhat.com,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <F3E94528-EA85-4A15-8452-EA2DE20EEB88@gmail.com>
References: <20240429072628.23841-1-zhangwarden@gmail.com>
 <20240505210024.2veie34wkbwkqggl@treble>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3731.500.231)



> On May 6, 2024, at 05:00, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
>=20
> On Mon, Apr 29, 2024 at 03:26:28PM +0800, zhangwarden@gmail.com wrote:
>> From: Wardenjohn <zhangwarden@gmail.com>
>>=20
>> livepatch.h use KLP_UNDEFINED\KLP_UNPATCHED\KLP_PATCHED for klp =
transition state.
>> When livepatch is ready but idle, using KLP_UNDEFINED seems very =
confusing.
>> In order not to introduce potential risks to kernel, just update =
comment
>> to these state.
>> ---
>> include/linux/livepatch.h | 6 +++---
>> 1 file changed, 3 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/include/linux/livepatch.h b/include/linux/livepatch.h
>> index 9b9b38e89563..b6a214f2f8e3 100644
>> --- a/include/linux/livepatch.h
>> +++ b/include/linux/livepatch.h
>> @@ -18,9 +18,9 @@
>> #if IS_ENABLED(CONFIG_LIVEPATCH)
>>=20
>> /* task patch states */
>> -#define KLP_UNDEFINED -1
>> -#define KLP_UNPATCHED  0
>> -#define KLP_PATCHED  1
>> +#define KLP_UNDEFINED -1 /* idle, no transition in progress */
>> +#define KLP_UNPATCHED  0 /* transitioning to unpatched state */
>> +#define KLP_PATCHED  1 /* transitioning to patched state */
>=20
> Instead of the comments, how about we just rename them to
>=20
>  KLP_TRANSITION_IDLE
>  KLP_TRANSITION_UNPATCHED
>  KLP_TRANSITION_PATCHED
>=20
> which shouldn't break userspace AFAIK.
>=20
> --=20
> Josh

Hi Josh!

Renaming them may be a better way as my previous patch. I would like to =
know why renaming KLP_*** into=20
KLP_TRANSITION_*** will not break userspace while=20
Renaming KLP_UNDEWFINED to KLP_IDLE would break the userspace.

Meanwhile, I will resubmit another patch renaming the macros as your =
suggestion ASAP. Thank ~~ :)

--
Wardenjohn


