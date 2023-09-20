Return-Path: <live-patching+bounces-1-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FC57A8D29
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 21:53:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CE4011C20A6E
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 19:53:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C6F405C1;
	Wed, 20 Sep 2023 19:52:19 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E3BF450CB
	for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 19:52:18 +0000 (UTC)
Received: from mail-yw1-x1134.google.com (mail-yw1-x1134.google.com [IPv6:2607:f8b0:4864:20::1134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF37DC
	for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 12:52:15 -0700 (PDT)
Received: by mail-yw1-x1134.google.com with SMTP id 00721157ae682-59bbdb435bfso2547267b3.3
        for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 12:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695239534; x=1695844334; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i6XY8wIMD7LjGNpegRcCUKrZA0w1gq5GxQRY7mj2AIc=;
        b=IBfe9QuYzIjLJoMieQ9UClN+pIjHMly/FiZINK7vZf8eX2tHxCJ/6Rb2NF4SAKW+hU
         FpJ8BvtJWozoQfGKaFS2QpgBqZLNwutXOUeKjWt4xr2vzw1WXDbdzqEkOi9oFob2/miU
         UjpHeeGdsXA+BfvdR9BaHw248Y7AGuZcMebM4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695239534; x=1695844334;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6XY8wIMD7LjGNpegRcCUKrZA0w1gq5GxQRY7mj2AIc=;
        b=kqUA6KvaW/Ib8AvgGmwSAf2p94G9kHjCOKUfDJuNVpzYJFDHiWwhcWkxqoNoxDZ4J6
         OoDdgebdClOIzq7yCAg9CjikObLBXquRKGN03z7uSX5Tojacajz3MkfdqwTMEJ9OnJqM
         tE8Mof3vjuCvETQ73x1YBAQZOdoRmGetwtf8FIp7FFYrUMlkDrGAZKceKGDvzUA8c0DF
         0SYB4s6s8q6L83mEaiDoXLgNZKkuBxU1qHWuhaJf4HfQQQDY3faYzNAQaDHGWOPbnldt
         gbazCzRhWAvekoEUCdO1LxCJXPKSTvTKJdOzIe9yfGtVa5HzjFNrXjQvOitbX+IMapsG
         5HiA==
X-Gm-Message-State: AOJu0Yy2uaqPIAE2+Rby0v2qwiTIJK8b2OGOoO/szyYTowG+HvfNneA8
	K7ngvf/Oio3tBQS7XbnuD3ejJA==
X-Google-Smtp-Source: AGHT+IE34WLE4Cfpn3/mrrUYZ+NVqbx/9khGu7tOlXbwDv4JWUwVQmIsGV3ZOglYnX/uY5dff3oc1Q==
X-Received: by 2002:a81:a087:0:b0:561:c5d4:ee31 with SMTP id x129-20020a81a087000000b00561c5d4ee31mr3955439ywg.38.1695239534737;
        Wed, 20 Sep 2023 12:52:14 -0700 (PDT)
Received: from meerkat.local ([209.226.106.110])
        by smtp.gmail.com with ESMTPSA id t6-20020a05620a034600b0076ce061f44dsm5062450qkm.25.2023.09.20.12.52.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 12:52:14 -0700 (PDT)
Date: Wed, 20 Sep 2023 15:52:05 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: dwarves@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-rt-users@vger.kernel.org, linux-rtc@vger.kernel.org, linux-trace-devel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: This list is being migrated to new infrastructure
Message-ID: <20230920-uncouple-grime-729f33@meerkat>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_20,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	RCVD_IN_DNSWL_BLOCKED,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	SUSPICIOUS_RECIPS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello, all:

This list is being migrated to the new vger infrastructure. This should be a
fully transparent process and you don't need to change anything about how you
participate with the list or how you receive mail.

There will be a brief 20-minute delay with archives on lore.kernel.org. I will
follow up once the archive migration has been completed.

Best regards,
Konstantin

