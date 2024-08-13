Return-Path: <live-patching+bounces-482-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 624FF94FC71
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 05:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C058E2822F6
	for <lists+live-patching@lfdr.de>; Tue, 13 Aug 2024 03:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0A8C208A7;
	Tue, 13 Aug 2024 03:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnJ2wQ59"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629901EA84;
	Tue, 13 Aug 2024 03:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723521235; cv=none; b=tN12urf80FQepBDElv8kJ6/RC66xEcjf9yJXb9Elqkirg2l88PHjrE0W/p3+YVijNW1IBg2IVihq0Wqfh2iK0bxyMLsKAwStmc1IdaDQzgablkrSoxkRIrpG8ddRZ7v0w81aBbgPROfmeylE/+Dw1TxcGww5cJh39fNZXDaUj/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723521235; c=relaxed/simple;
	bh=bzzkOdYjZnt3NwRR0zM1nV4+wHGZRcHbO0WP+1KwHyk=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=CxcB+1ZnDve1blS2Of6GilihoXfLwAV7Z8oem8cIzE7WI9jHEr8RelzXcH1hgCL+YTvOIES2oUeoz7hXVg7vn1U8NUIO3ghBll4irvC2o6bSyS41nrJlrfe5u5BrR01Lv9zFF/m0TnuHENZ9pVRLmJHMNELPVoCveCk9xeI9It8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnJ2wQ59; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-3db16a98d16so3109110b6e.0;
        Mon, 12 Aug 2024 20:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723521233; x=1724126033; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tN/ZRWVHEHWYN/MyGgywTnPix3p+IROxtn8nqbPNIJA=;
        b=JnJ2wQ590ktdeOLvytKXX1qlH8IkcpiBm0utYOJUOgHh2FgUMjAxTx7rZxT9QiTFDa
         iTd/PQ/YKD6PFtaJKrKu+zyvi5xOW+5QMsyqyCQwsgXMIV6t4aJBcawUjm2xgHtn96vc
         qjK0TkDqweizBWH0f3OMdDXP42aZ7Uo0Qn348OMESmNBVEB6o+P77Igwa3sy0IafXW21
         aUHqHrEFZVFRUlafxNbnzp/WsAdXoY6SvtvAD5QSCmOvQ6FIzXB7PQ25+T1r8qVyo8dT
         +AHxiLNZCpwsryX2Ud2VKjx+z1+BbH9Ejt7a5r//xxQgzbDLaL6WSM/AxXxowRAfqsLg
         o/Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723521233; x=1724126033;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tN/ZRWVHEHWYN/MyGgywTnPix3p+IROxtn8nqbPNIJA=;
        b=h7xC9iC2ghB/yt8r9TbqTrx1P3Rc5ZhBzmZJtqVRMlo7yk5zKphdiWB5990TTgTAHI
         5L/1AK5umqaFYGSDbTsE/mMbpAuwNtGp4be4jHClFji4IjXXMzGI5hAhKuAFR9nqDDEV
         ++8foGOvp2XBQnbPh/SWbgdZRGSE+Fpo9fvFrZht3qci4ku9SG8OSQbk3Ghold4Md/Kz
         qiJwSOtNkEGNuRZ3EJts9M3GERGXChEM6+gd1zXHYnbAbXy7Vf/Eh/Ylvlsv1vTDwR+t
         zg0R9db6mtcslyH413Ww9Vwv6UeaYmFFR8JBPRfuSLBzBbOwQ2HMEZl/SFWXy6O5F1YZ
         6wyg==
X-Forwarded-Encrypted: i=1; AJvYcCVi7ZEdNfpZIUxeJBCdcsXKk2cwTnOWgvAmaitHPRf64oEE1u8jcA9cI9fP6/Pn5Flpv9Ug/fQK2yfRkMsbEA6zN0ZseKdpnM2n0dj3
X-Gm-Message-State: AOJu0YyWNcJdPLD3sF9sXH/bmP1UqOCYTjp4DWJfreMsi5hoqn7g1KD+
	VBAleG5nFpEmJGcU7w9GhysDxrQkycBknzGdEAdxLlhsdJdK1jQfPER8IykeMw0=
X-Google-Smtp-Source: AGHT+IGSaYxy1mZueLxy1ybCQRdMXARaSDlaNa5WLDIyMssupYABKl5Y/uPucHwGpdXkDnkPPC+JUQ==
X-Received: by 2002:a05:6808:3994:b0:3d9:303a:fc6d with SMTP id 5614622812f47-3dd1eede067mr3085010b6e.41.1723521233318;
        Mon, 12 Aug 2024 20:53:53 -0700 (PDT)
Received: from smtpclient.apple ([47.89.225.180])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c697a08f0dsm459800a12.44.2024.08.12.20.53.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2024 20:53:52 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH v2 1/1] livepatch: Add using attribute to klp_func for
 using function show
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
Date: Tue, 13 Aug 2024 11:53:37 +0800
Cc: live-patching@vger.kernel.org,
 LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <8743E498-1B7D-4E05-9B9D-4A243089BDD3@gmail.com>
References: <20240805064656.40017-1-zhangyongde.zyd@alibaba-inc.com>
 <20240805064656.40017-2-zhangyongde.zyd@alibaba-inc.com>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Aug 5, 2024, at 14:46, zhangyongde.zyd <zhangwarden@gmail.com> wrote:
> 
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> One system may contains more than one livepatch module. We can see
> which patch is enabled. If some patches applied to one system
> modifing the same function, livepatch will use the function enabled
> on top of the function stack. However, we can not excatly know
> which function of which patch is now enabling.
> 
> This patch introduce one sysfs attribute of "using" to klp_func.
> For example, if there are serval patches  make changes to function
> "meminfo_proc_show", the attribute "enabled" of all the patch is 1.
> With this attribute, we can easily know the version enabling belongs
> to which patch.
> 
> The "using" is set as three state. 0 is disabled, it means that this
> version of function is not used. 1 is running, it means that this
> version of function is now running. -1 is unknown, it means that
> this version of function is under transition, some task is still
> chaning their running version of this function.
> 
> cat /sys/kernel/livepatch/<patch1>/<object1>/<function1,sympos>/using -> 0
> means that the function1 of patch1 is disabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> 1
> means that the function1 of patchN is enabled.
> 
> cat /sys/kernel/livepatch/<patchN>/<object1>/<function1,sympos>/using -> -1
> means that the function1 of patchN is under transition and unknown.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
> 

Hi maintainers. How about your suggestions to patch V2?

According to your suggestion, I made some new changes to the V1 patch.

I am waiting for your suggestions. 

Thanks.
Wardenjohn.


