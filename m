Return-Path: <live-patching+bounces-730-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 093E79999D7
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 03:51:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCC0D281F55
	for <lists+live-patching@lfdr.de>; Fri, 11 Oct 2024 01:51:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9BD91754B;
	Fri, 11 Oct 2024 01:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2OwqSHT"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E72BA2D;
	Fri, 11 Oct 2024 01:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728611484; cv=none; b=U0/0Jauy5jukH+GWM1R6qaaHkvoKCuOFPv7CoDrvLUj5Bz56vfPPSXNuGpN+IebGqEsiLa3sq0LZ2SMFQSklPB5VUlFiitUJvRWCY3Yix1ge9vT5ygt4SFG6Zhwu1rhF8qHZA/Q/rKoMb1rcWtOpfnEjn31tPYa+XAZoOcf5LOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728611484; c=relaxed/simple;
	bh=PtdviKKk7BYJsT8HCL3OErtWb6Ij60rucfI5aT48XUo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=IRT9UjJeOHyBCocd8fz0H5Oz5UOdR+3YGffbSvfJsaOwLxSA8fa/mzu9MxB9x1xTZ/CO8UVP+CcdCHwG3ZAIo5xOF/SDPnx3iZCCIzoe6pW6sAFGPPQlJXS7jSt5uiqj+sb7svkmaBpabU77SKiXa5/1AIW/kFIKbgVk80bdwAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a2OwqSHT; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7e9f355dd5dso732178a12.0;
        Thu, 10 Oct 2024 18:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728611482; x=1729216282; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eOmqM3r8vBvfHNvRWfpbxFBCiFEI27vwU4wJeJYBbk=;
        b=a2OwqSHT2VuYTRu6hfG3EGhl0AE1SYCLoRYsQsfEhakAYYOVOBYPT1RuK+vouZZs1d
         AZgsTdHz/6lAYeFaCizVab7yW4Vo8k5ESRNCPKSl6zONgJbyXWhrNNhVaPFd/2kInK0W
         ZZVgq4NYDZAONZmGzzKeMcpMfcQA/4JOKBAMnQuKJJ5p/FUOUynF6my8vAZzbGnDDbBz
         rjlFkEKOMswllUlrBmzYEd+Bv3NJX0SK9ZE2zs0tNM1ICDW04CRmqUg+npDh3ZHTQlWe
         mI5ambkvFgCVOdyCuWhyBg5DK3YJzo1HddHzpJe/Hf0Bi9YHX8TNVsKJF0qzK82Mfjo0
         eoOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728611482; x=1729216282;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/eOmqM3r8vBvfHNvRWfpbxFBCiFEI27vwU4wJeJYBbk=;
        b=OEELdJFuOHMt0yFE185juuU23E0ur64r3U9NCdiCnT9rh6ht9Q6TzAf0VvWOSaiJPu
         fIy8WoL3k6uFYvR3Dmqn83CuT8gRK/P3mOyknKllwyfKIMH4+XTsUVp0XzVst2wHrdYT
         hz78mMPCIw/NocC4yeJkvp/qBhHLdXnExozkrcYnkSYydODXmzxGlEkXtf6beBB4DBqv
         3OJE5xzrhwt++QPCyFTB0SnK+kGzDZTdo32E3DKl9ql2afi5046uImFHfY1PLrmQW2Wv
         00fS0Hd16+J9YW2gZVQLLi6yC6CGf6Q3qINTlvJJ5e0VwRJwDyJfMsjVG8cMRUcfOxzZ
         /GOA==
X-Forwarded-Encrypted: i=1; AJvYcCV6f76Ji2fyaRwub2nhblGNmeq/VfmQdelQydxSfXQio/N+l68X81H/ZLYiHDoGzyfuEvs/OeyBFUtsVtU=@vger.kernel.org, AJvYcCVuTHJlk1avwunrJ2k8Z8KTYHwt4G3A3HH7aEgesZP7sMDQHLSwE1lzXriwbBprm2kk+gy5KAx8NcufkimRSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxKZuVT1mj6J/eXDIaX9N2IHw+V5WTxcdKZqWkVmJHxk0B+pJXM
	pPjfbws8RpU03zE9A/e5ApDWo6o30klH1WDqZpsdC6Pn+wDMPboM
X-Google-Smtp-Source: AGHT+IEEwZ7gTxd61zH4m2CGU5MYPaFtqjgvLz94e49/SFkXVKtj7ZSdJ+i56+R57b4yoIdgUWU+3Q==
X-Received: by 2002:a05:6a21:3514:b0:1d8:a29b:8f6c with SMTP id adf61e73a8af0-1d8bcfbf1ecmr1576951637.44.1728611482478;
        Thu, 10 Oct 2024 18:51:22 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7ea448f9380sm1652162a12.26.2024.10.10.18.51.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2024 18:51:22 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH 1/1] selftests: livepatch: add test cases of stack_order
 sysfs interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <20241010155116.cuata6eg3lb7usvd@treble.attlocal.net>
Date: Fri, 11 Oct 2024 09:51:07 +0800
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <CDB9AA87-5034-40BB-891B-CC846D7EEBDA@gmail.com>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
 <20241008075203.36235-2-zhangwarden@gmail.com>
 <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
 <A35F0A92-8901-470C-8CDF-85DE89D2597F@gmail.com>
 <20241010155116.cuata6eg3lb7usvd@treble.attlocal.net>
To: Josh Poimboeuf <jpoimboe@kernel.org>
X-Mailer: Apple Mail (2.3774.500.171.1.1)



> On Oct 10, 2024, at 23:51, Josh Poimboeuf <jpoimboe@kernel.org> wrote:
> 
> Maybe add a replace=[true|false] module parameter.
> 

How to do it? 
Isn't the way we build modules using make?
How to set this replace value?

Regards
Wardenjohn

