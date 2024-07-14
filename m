Return-Path: <live-patching+bounces-392-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F569930C28
	for <lists+live-patching@lfdr.de>; Mon, 15 Jul 2024 01:13:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FAEC1C20CD6
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 23:13:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1B4213D28C;
	Sun, 14 Jul 2024 23:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NkbZ5uEd"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4283027452
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 23:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720998785; cv=none; b=ANPxzVMvfj2+Q8OFn/Vys/DfKHRY0iRH9R1suJWQxWyuroyJKM2Vu5EFC+0/fMXT4eC4GNavgrfouk5Gdg50qmd5D5ccNU+pL7aRrxZ7+w9pdCeHy7zwQfnZDyGYSc+MjYXgC/lrt0c7Eq77yi1+eMywwY8qNqtD01rSYMOcEIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720998785; c=relaxed/simple;
	bh=3pCbXD7DfVguYJddwVmMQ9JLn7zY/MlEsXgkfrLuo3E=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=c0fTbyKSu/KfZ6vHuyB8LrbnOvbs99wkJOEUilcVza7UemHPSVbv2hTXYfNP5CH9emhsrONdZ3ngYx6mwnUGSpP7C15IXHoC+6Mgx93pgoI0ELUErsQoq68iGAZXrMNNOP+WJhonDacOukVCnKzKa4gX0c6V5B3YRHYYHcRiCX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NkbZ5uEd; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4266edee10cso23175395e9.2
        for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 16:13:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720998782; x=1721603582; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bLtPAfh2E+MA5JS7i0e6T7XOoE8ozctk2oYloQR64hU=;
        b=NkbZ5uEdWwDK6m83VUseJHVl2QyG/H8UxlFi+Va2ZsEXcArtjwxHOwQCGF4opL6phF
         3zCb64pi2BcO26YKtpcOjdh1zpOxY4kvXAfdCIwMPoT97oKyPbHmccHanEC/0++UuyBv
         w91kQmvqe22JZALLQ+bHKzjmEA5XblBdLE+iNwImCkWg1Z2F3bCg0cj+1AbR7fUzBg9p
         rGM+hdlH4VWBBSdILFOQhXMs635n5YglFzNJG4e/7kb7mgqYDcWaKwXfqivCF4cuKfCs
         dCCZ35cmYlRV33Myc5W6t6cRKGGvSlJqYyanUK8guMkaX+uNB3mlOCGRVOvjD9idoqVH
         lpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720998782; x=1721603582;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bLtPAfh2E+MA5JS7i0e6T7XOoE8ozctk2oYloQR64hU=;
        b=Or+cGDsrsk3EuqRmZYg3bNA0EYAL4oeQeBROTY862IHdGuzdv0o2DIp3wr9Vwa8Xhb
         nVUx/UrxUhg1Hdtcejhdw9ObwsFwgESrFWQWcei5o+qFeDpoRiR4Z1gi1oZ7uC5ZgoYY
         Z17K07rXCDBtlBH6ec2oh6iAXn4haZKExC/jFr1OPbnNW7bqFUeR2uqXt6MxUtsO9dPD
         3pVj7n7GAMpjV3aoTpmrZQGFIQzwQ/Kr7JIkdYnlUrY/RK94aP4mIreo+fD6jlRMubk2
         ipXmsQWGI47fGrSDHfwbW7Vkw/7u0+Ib3szV6Q2htR/DmnDcrZMUgzHzglyjzh4NXtsW
         u5+Q==
X-Gm-Message-State: AOJu0Yy7un+02RsDa+xULOYSzWbfweU8wbQmCzm3JR9JK62h3LiUmYJr
	n1v6nS3kxDCTCZiqQUO4fE6MKqZ7VxYT/YRaRhXCjmNWX+8oVS4/00nSz4pZC1Y=
X-Google-Smtp-Source: AGHT+IETnNxnr8Mli4iF5r6ipnnncNYnHrcKS6Hx2QwlmYJ4+mxmcUFAdxcgm2H1a9EQc72h7+9fQw==
X-Received: by 2002:a05:600c:4998:b0:426:5b21:9801 with SMTP id 5b1f17b1804b1-426708f2197mr93194615e9.27.1720998781763;
        Sun, 14 Jul 2024 16:13:01 -0700 (PDT)
Received: from [192.168.225.17] ([77.222.27.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5edb478sm65328405e9.33.2024.07.14.16.13.01
        for <live-patching@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 Jul 2024 16:13:01 -0700 (PDT)
Message-ID: <809917ce-f400-4f7b-9991-fd1089a7886b@gmail.com>
Date: Mon, 15 Jul 2024 01:13:00 +0200
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: live-patching@vger.kernel.org
From: Roman Rashchupkin <raschupkin.ri@gmail.com>
Subject: [PATCH 1/2] livepatch: support of modifying refcount_t without
 underflow after unpatch.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

[Forwarding reply to quic_jjohnson@quicinc.com]

Thank you for interest in these patches. I've actually originally built 
kprefcount as a module for testing, but do agree that it doesn't make 
sense practically, and MODULE_LICENSE() should be removed from 
kprefcount.c, as well as kprefcount_t API generally be improved.

Idea behind kprefcount_t algorithm is to facilitate creation of 
live-patches for CVE fixes that add refcount_inc/dec() to existing code, 
as this type of live-patches often cause problems because of runtime 
ordering of refcount_inc()/refcount_dec()/patch/unpatch.

If implementing such patches with kprefcount_t, only new live-patch code 
would be modified, and also patching of  functions  that call 
refcount_dec_and_test() is necessary to instead call 
kprefcount_dec_and_test().


> Note that "make W=1" will generate a warning  if a module doesn't have a
 > MODULE_DESCRIPTION().

 > I've been fixing the existing warnings tree-wide and am hoping to
 > prevent new instances from appearing.

 > One way I've been doing this is by searching lore for patches which add
 > a MODULE_LICENSE() but which do not add a MODULE_DESCRIPTION() since
 > that is a common sign of a missing description.

 > But in this specific case it seems the MODULE_LICENSE() may be the issue
 > since I don't see how kprefcount.c could ever be built as a module. So
 > in this specific case it seems as if the MODULE_LICENSE() should be 
removed.

 > Note that none of the other kernel/livepatch/*.c files have a
 > MODULE_LICENSE(), and CONFIG_LIVEPATCH is a bool and hence does not
 > support being built as a module.

/jeff


