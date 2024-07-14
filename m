Return-Path: <live-patching+bounces-388-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DB263930B6C
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 22:00:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8FECC1F21349
	for <lists+live-patching@lfdr.de>; Sun, 14 Jul 2024 20:00:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32E1413CFA4;
	Sun, 14 Jul 2024 20:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I+whJMdf"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70AAE78C94
	for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 20:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987207; cv=none; b=pEOj36JTdfOZ+MmZLL4xwiYAzRIKq07o4ij1m+rw4YM5imC4Ibu8FYofoL/+GJ7cddOlGTg6DxRB9Yv+a0eO+P9RaxVLv58jTWs32GWwLPDS2oJkVzN9PNSwBcYd+wd1X6C0dUDg5bVlil5eMk7MgfUMajNOPXosMWf69ltkETs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987207; c=relaxed/simple;
	bh=Tc8XHhUXVABAhpTWbsfutwDtn2XcYhFB1yrgKFlzeEY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XXJo0kUbG6/NaYG9Ic6yQu3E8hIrkH3E33/JLCDIdY1w/lbHXZkO3mju2ZHgXAKGPfeWQx6KxeP+LhWJ1F3J/MA/gFY+3q5aLnT1xa93jI0oAo0OAKEeHEco7trSHImAMkj3qpsJjcWSePpz/kMpYfLwSvM6OU2ErAw7RrSrlF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=I+whJMdf; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-52ea2f58448so4887499e87.1
        for <live-patching@vger.kernel.org>; Sun, 14 Jul 2024 13:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987203; x=1721592003; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Lq5/qOHOGrx0qk72qvlrAWQW35WsiwJW+zstbN3DCXo=;
        b=I+whJMdf6PvH50LmKdQIsWCbX7Nv1QSijZdbD2Sl92EsNuF3ynQ147DpD9QyQx1u0q
         QR7JG9a6UcH0imrkWJX23ydcZOdFSh8XQ42FVJIQ9UHZDXrMVx1BJO9q4Vidh9Cr1NFn
         F5SzIs1MAWmfne4/Bfyp5qumdsn1Ee02Z8dp0mK9QPeAN0qS5J/4Wtync2tMJBrbXbaH
         rLfEKW3Df5CwCI+DYUnWuti0KvjKv8qJRkXSu6tGglDyEy+wQFfdDwp5Jp+5iinP+qRm
         zzeWNQ3fmE7nsqRzMyAZcZneQcANX6qPB8VGOTkS68wE5ZzJjG46RBsomMnjx3pllfv6
         JHtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987203; x=1721592003;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Lq5/qOHOGrx0qk72qvlrAWQW35WsiwJW+zstbN3DCXo=;
        b=rdLS3DZ1kQ7J6w96I/PtkiJElwDNiy1k2ydH7eSpp5fR2kg/OUD5BCVAtKIJ9PyphO
         +7c38xu57hIi/g5P1SHUUftZbyIuWIMDF+L87q03JeVPC1wAsOHoXPsBNKxJklSj3DIS
         Op9Io1/wldCIdLcUf+6nOcLv0bAfBg5CUKUYGX2i+ep0S0PrBhTJr5bMyPqYV2gftC6E
         8OXL5d5duLW7z8sUD09hC8BMMo04GZQ7Yf1YY7LN8gDHXJynEBjkieLbC1wtR9nGHvsv
         31L+eOARE+Q2EmDp9VUxJj+7Tpb3jsoCs98rNXU3UIXfZjeyCsDbLVr0jTh5xx7UUvH9
         /Rng==
X-Gm-Message-State: AOJu0YwWNlVH2PE3JHNmMLQwX0AzsCzvJNdCG2kMpwpOgRwNDpEAbYuW
	JcjJfIO100J87v9yYX0DEiat5RoyaWRlfH0kYbQIRu1wr4as7J/YYGTwC23VpJQ=
X-Google-Smtp-Source: AGHT+IFOx3Qu90CdZ5B/DT2EvEKuC+Lr+IW/WIBafohdMEMZ72OlOZgmB/nA0EVQGmpWPTaBVA+sYQ==
X-Received: by 2002:a05:6512:ad2:b0:52e:bdfc:1d05 with SMTP id 2adb3069b0e04-52ebdfc1ffcmr11014902e87.44.1720987203001;
        Sun, 14 Jul 2024 13:00:03 -0700 (PDT)
Received: from roman-work.. ([77.222.27.67])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-427a5edb525sm61145985e9.34.2024.07.14.13.00.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:00:02 -0700 (PDT)
From: raschupkin.ri@gmail.com
To: live-patching@vger.kernel.org,
	joe.lawrence@redhat.com,
	pmladek@suse.com,
	mbenes@suse.cz,
	jikos@kernel.org,
	jpoimboe@kernel.org
Subject: 
Date: Sun, 14 Jul 2024 21:59:32 +0200
Message-ID: <20240714195958.692313-1-raschupkin.ri@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


[PATCH] livepatch: support of modifying refcount_t without underflow after unpatch

CVE fixes sometimes add refcount_inc/dec() pairs to the code with existing refcount_t.
Two problems arise when applying live-patch in this case:
1) After refcount_t is being inc() during system is live-patched, after unpatch the counter value will not be valid, as corresponing dec() would never be called.
2) Underflows are possible in runtime in case dec() is called before corresponding inc() in the live-patched code.

Proposed kprefcount_t functions are using following approach to solve these two problems:
1) In addition to original refcount_t, temporary refcount_t is allocated, and after unpatch it is just removed. This way system is safe with correct refcounting while patch is applied, and no underflow would happend after unpatch.
2) For inc/dec() added by live-patch code, one bit in reference-holder structure is used (unsigned char *ref_holder, kprefholder_flag). In case dec() is called first, it is just ignored as ref_holder bit would still not be initialized.


API is defined include/linux/livepatch_refcount.h:

typedef struct kprefcount_struct {
	refcount_t *refcount;
	refcount_t kprefcount;
	spinlock_t lock;
} kprefcount_t;

kprefcount_t *kprefcount_alloc(refcount_t *refcount, gfp_t flags);
void kprefcount_free(kprefcount_t *kp_ref);
int kprefcount_read(kprefcount_t *kp_ref);
void kprefcount_inc(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
void kprefcount_dec(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);
bool kprefcount_dec_and_test(kprefcount_t *kp_ref, unsigned char *ref_holder, int kprefholder_flag);

