Return-Path: <live-patching+bounces-1097-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 65D7AA23E47
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 14:22:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D745718822EC
	for <lists+live-patching@lfdr.de>; Fri, 31 Jan 2025 13:22:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE2B1C3C0D;
	Fri, 31 Jan 2025 13:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qjt4oI45"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453561E4AB
	for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 13:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738329765; cv=none; b=qmgs/cn36gHDvCFSYVgsPzKGBVoHlanqVCxvUsDlVPknOw7sbcKdO2kUVKOFeEvEoPIHSSFHsaYuYfctk+/iT3LJztV8eMhKUoEsVQeZFIwl3uOiawKRtqSThDYMAEDvfOWWMGQFGnw1nC+HAzl3N1aSfXnIuaT4QuHJ1RblRAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738329765; c=relaxed/simple;
	bh=nzfv9psWfaqajeuApEEpXrt9Re9jOtNB+WoM0lwkR5c=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=njgpem/8S07579hd/x9syF83GjWpo56/OMJ5HZbWKTZ4J5ZDapydLN+YbJHUvy9PtYZQHvQ5N+D81wNzkUH6bBztt+OVVSNCUIfYSRNzJAEx7zJ4wygLPRVD5GpCo854D2YQjG/Tov5nbCez8I3/2GYZHPk4RHpws59rGqSu5XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qjt4oI45; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2ef6c56032eso2604227a91.2
        for <live-patching@vger.kernel.org>; Fri, 31 Jan 2025 05:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738329763; x=1738934563; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nzfv9psWfaqajeuApEEpXrt9Re9jOtNB+WoM0lwkR5c=;
        b=Qjt4oI45FuMV6nbIOUgMH4gPtyxL36/cr5kImQBhW+myomXDWLnx9aKlC6zMhBATiS
         Ds82hRAGk16mpjBLM2NEGZZrxZUDaXx6p/I53D6GH7W0W3uAOHNtaVYo5PM5nNd5Q54c
         ogZaMYjSfSU7C7VVzyCxlr8VmZ778HitUErIjmfzink818IQ+WEMEOxbeX8s53sbFng6
         7ZXP9bPcj9wCz8DGlxtBZolz9kC71Fx/mmy5RrTkIxUzj3/VnMYA9MyL7ij9EW9xJQUd
         DrJqLW3fEBo9zokqaAzZKjDxm87QaYCbJ2loP0Pxc7uc4A+QjM8lwGBOKwulYqc71H5H
         JPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738329763; x=1738934563;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nzfv9psWfaqajeuApEEpXrt9Re9jOtNB+WoM0lwkR5c=;
        b=dJmvWjxcmTqdXogPrBX6pGM8hVb75NVOg+knZUj/l6ysOnqspcEMyiK9iKz0xSIUA/
         riJuyiyqV0drs2hDzGi8BC761yetPzSXcUaZGJcecNN4PKjRyCnmu2zoR5K0L5SEQvu2
         gAdVEjhXUcQ8wEV96x4erBL8C+a0ecnFsBf3nqkq6t1OLI25vslRdzj37pQjKDMml8dT
         6YuI35qLqOCHPQZxS3mYRyNwKOAfFD+rxG6/urAhSQQLwj5mMJtI4vKLWp9DV4dk89kW
         0hfY2CWBMW6yOWSQ3aVXYMgCF3/2ICK8eLiekRouD4qWbQ/kNrFgsESWR+YsLUrW2VIi
         w82Q==
X-Forwarded-Encrypted: i=1; AJvYcCVMpajwqe9FuOcqVSYpzDcdE/w8PWPBUssdGHUEcjd8S7MexykkZr0Gtpag76N2l5OJR5Ll3SwI9TkNeeWd@vger.kernel.org
X-Gm-Message-State: AOJu0YziIafuh4CS/csMkp/17HkkQSn69oD4XzVAk5OZWJm1g781mOHG
	V3xlavuBGr6zzcmJ4BUQRMrjFmje3TcNqzm/O4xnBIPRlTZRrMfB
X-Gm-Gg: ASbGncuv79WyUutXHUlYb4stmze7pIROe+arAD3bnFVrSAUvFArmNXgP2NBerEjQ23z
	fNmkreiuVJbw4Kd7uS/9ee7zLg6Hj3pOqAyfPJ3QPyuoZp2oD3+12SBxJhPoD3boy2mus9lXzRO
	ammo4/miRtV/ytpbG+03oJpyU8Vi1QKvqjmjSgHqHC99Pu5XgJzJQGhIYr+kAFinoJUBXzncfUF
	BC2Nm6kEFUmNrW4JkC2Q8Pd0bBGw1OdP3q2E8j/OOfyx8D9yT3I5Mj3tNyjaJEX2pBVNddUAHkq
	+thTUBSeSnOO+NCI3Q==
X-Google-Smtp-Source: AGHT+IHuTbjwbUCMiPgcwnkpzg9P+2X8I0hk1eoepq6fGd8/TRcTS43O7tQMQ24f38HQaJGwO2UJoQ==
X-Received: by 2002:a17:90b:2747:b0:2ee:599e:f411 with SMTP id 98e67ed59e1d1-2f83ac8b1b0mr13900018a91.34.1738329763305;
        Fri, 31 Jan 2025 05:22:43 -0800 (PST)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f83bfbfe19sm5799731a91.44.2025.01.31.05.22.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jan 2025 05:22:42 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: Avoid hard lockup caused by
 klp_try_switch_task()
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
Date: Fri, 31 Jan 2025 21:22:13 +0800
Cc: Yafang Shao <laoar.shao@gmail.com>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 mbenes@suse.cz,
 joe.lawrence@redhat.com,
 live-patching@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A250B752-FFBF-4A53-B981-FE6D9A9F5C14@gmail.com>
References: <20250122085146.41553-1-laoar.shao@gmail.com>
 <Z5DpqC7sm5qCJFtj@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Jan 22, 2025, at 20:50, Petr Mladek <pmladek@suse.com> wrote:
>=20
> With this patch, any operation which takes the tasklist_lock might
> break klp_try_complete_transition(). I am afraid that this might
> block the transition for a long time on huge systems with some
> specific loads.
>=20
> And the problem is caused by a printk() added just for debugging.
> I wonder if you even use a slow serial port.
>=20
> You might try to use printk_deferred() instead. Also you might need
> to disable interrupts around the read_lock()/read_unlock() to
> make sure that the console handling will be deferred after
> the tasklist_lock gets released.
>=20
> Anyway, I am against this patch.
>=20
> Best Regards,
> Petr

Hi, Petr.

I am unfamiliar with the function `rwlock_is_contended`, but it seems =
this function will not block and just only check the status of the =
rw_lock.

If I understand it right, the problem would raise from the `break` which =
will stop the process of `for_each_process_thread`, right?

Thanks.
Wardenjohn.


