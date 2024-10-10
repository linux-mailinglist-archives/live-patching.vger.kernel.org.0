Return-Path: <live-patching+bounces-728-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C80C998B14
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 17:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5C4BC2936A4
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 15:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB94438396;
	Thu, 10 Oct 2024 15:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="G0nY/TFi"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65163B646;
	Thu, 10 Oct 2024 15:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728573135; cv=none; b=S0aNckWzsTkQgXIxOjK3r1Hj63SPOT3EGjuIQA8n735Q+522OHggRc+VVIira3UnGft9pQhuPyyxwXImLLi4LmtVKiPAk1VAd9q0PwBsMDE3Gru1P79g4X2+FIdTdmnRHFNEx5hIKlZt65IsCAH2CloMAVeL3leV4KA2bHebHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728573135; c=relaxed/simple;
	bh=Q8tKfHUob6C6DwmMtFCXCVA2tF6kD/Zv8ffO5E6R9JU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=UJXZZx1mB+Q82vqnpqy/xt+dEVKvURfG/VJwa4WT/8X87tP64loii+3cWLp/qWw24GEH1HqxP8fmazghDIO1CFQPMxvrrpzwX2q1/yCy3ss77bTyjDJYk12V0RI2Denm+p1ALZCjZl/o4Xg/COmI0r9ehT/X+wzTpwPncWHKKdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=G0nY/TFi; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20c544d345cso7301425ad.1;
        Thu, 10 Oct 2024 08:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728573134; x=1729177934; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H7DNcXklqLsJpINe8LKfEqhSKZ+jqVjX1eqMsN/PmO8=;
        b=G0nY/TFiaRdYHmB84MNlsA/u/wRSVllsZK5xCkDYRDwgBt1kvArcS4YcopWg0in3YH
         bGIimhTAYfSblGnxiT1CiBbrWWPCJu2W+VXrqhN433jG1MHp92dmf/ayl/VFCBdc9S1t
         25yGqMcamxQHpNpaBegMEky5pPBuln+MYcQ7tu8agjjymSLhbJbOjaUHwzhFg5E1JIPi
         +S9ZXPjkCMNWpvXDjpyW9PZ3tUs/p+HWM/T3aPC6rK72ON0R6PTT1cd9ht28oosXtZg5
         Bde7MyhWviBXHY3HALR1M8HIyD3P71WN7rgJDhsQ1jP84XUWK3KihPTnKPLtPcifwSr8
         hvSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728573134; x=1729177934;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H7DNcXklqLsJpINe8LKfEqhSKZ+jqVjX1eqMsN/PmO8=;
        b=CBUdxxA8R7/Ysp3GaoFRFFi9wcsbIq51qwuMWa7X4Dd/JEs56Iz5u6+0C5lM+UkLfi
         WK/FX7R3Wti2lGQO0wLskHd003jLfX5gCF9UoXsEBsOuZoiVRTXioxeJJocIGATB6/MY
         JGxmxozqfLgUzZvXkKJAfYQ8oJKgNJZq7d5HcPFyHG8Lk/a8nQVPLdn6Rjbmz9Q7Tg+o
         zCPRz0p+hDS1mfXv1KwswDvGnDDmoCEEQ3SikKW6zI4NWlNyFETVkyATBpUxsWZnyazD
         hLKqxs7WTOy2i0JlXrSsr4EC0sxu2iegJE/3uNsebFBrEL0UyTu0NL4xRwFyaPHNJm+n
         pqMw==
X-Forwarded-Encrypted: i=1; AJvYcCUoLJUSf9sUZHs9/lWVVL6uRe18+qzT1+w9gezDyqAIzNmKUuKCGyIxmBd3odCYYj5FjdGmZjE+DYQACwnGqA==@vger.kernel.org, AJvYcCWOf3CYLf5H0YWj5zpu6cHcdrZmyPPwnxT5BkuiyhPo3kXy57PsxBhkUWN2OIBa3YUMtzxVYyZYJSlWtt0=@vger.kernel.org
X-Gm-Message-State: AOJu0YweiMjx7iqPRdVmo63UkwKBzy7lRBUGmEDscV0cQ5u79C6m+wol
	rzT04Zx+pYuHz4+EG87BIufKWq/GMEoSfuCxvzgCA1ij6IEk9KJc
X-Google-Smtp-Source: AGHT+IE8p/8PG3EwwQFEQI0kSrl13+BXFRiot0wGvpOxgDqQ4pUa7CB9WYGy7SxaOVhpfnlPLw7vEw==
X-Received: by 2002:a17:903:32d2:b0:20c:7509:d958 with SMTP id d9443c01a7336-20c8047c240mr55603805ad.5.1728573133652;
        Thu, 10 Oct 2024 08:12:13 -0700 (PDT)
Received: from smtpclient.apple ([47.254.32.37])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c8c33e41esm10486395ad.257.2024.10.10.08.12.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2024 08:12:13 -0700 (PDT)
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
In-Reply-To: <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
Date: Thu, 10 Oct 2024 23:11:56 +0800
Cc: Josh Poimboeuf <jpoimboe@kernel.org>,
 Miroslav Benes <mbenes@suse.cz>,
 Jiri Kosina <jikos@kernel.org>,
 Petr Mladek <pmladek@suse.com>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A35F0A92-8901-470C-8CDF-85DE89D2597F@gmail.com>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
 <20241008075203.36235-2-zhangwarden@gmail.com>
 <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
To: Marcos Paulo de Souza <mpdesouza@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi, Marcos!
> On Oct 10, 2024, at 20:31, Marcos Paulo de Souza <mpdesouza@suse.com> =
wrote:
>=20
> On Tue, 2024-10-08 at 15:52 +0800, Wardenjohn wrote:
>> Add selftest test cases to sysfs attribute 'stack_order'.
>>=20
>> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>
>> ---
>>  .../testing/selftests/livepatch/test-sysfs.sh | 71
>> +++++++++++++++++++
>>  .../selftests/livepatch/test_modules/Makefile |  5 +-
>>  .../test_klp_livepatch_noreplace.c            | 53 ++++++++++++++
>>  .../test_klp_livepatch_noreplace2.c           | 53 ++++++++++++++
>>  .../test_klp_livepatch_noreplace3.c           | 53 ++++++++++++++
>>  5 files changed, 234 insertions(+), 1 deletion(-)
>>  create mode 100644
>> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
>> eplace.c
>>  create mode 100644
>> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
>> eplace2.c
>>  create mode 100644
>> tools/testing/selftests/livepatch/test_modules/test_klp_livepatch_nor
>> eplace3.c
>=20
> IIUC, you only need to test the stack order by loading LP modules. In
> this case you could use our currently existing LP testing module for
> that, right? That's what we currently do when testing different sysfs
> attributes.
>=20

Yes, in fact, those three module I submitted is reuse the existing LP
testing module of 'test_klp_livepatch'. Because I found some module
in test module set "klp_replace" attribute true. If a module set this
attribute true, it will disable the previous module.=20

What's more, testing this 'stack_order' attribute need more than one
module, hoping to change the same function. And breaking the '.replace'
value of existing module may not be a good way. So I decided to copy=20
more test module with '.replace=3Dfalse' and this module is changing=20
the same function.

Regards.
Wardenjohn.=

