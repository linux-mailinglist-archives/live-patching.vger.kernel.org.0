Return-Path: <live-patching+bounces-687-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A085987F97
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 09:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB56C282B9D
	for <lists+live-patching@lfdr.de>; Fri, 27 Sep 2024 07:41:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6117917DFFF;
	Fri, 27 Sep 2024 07:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CmQb5/xE"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371017C98D
	for <live-patching@vger.kernel.org>; Fri, 27 Sep 2024 07:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727422905; cv=none; b=rX01e+fTAo7ZSLJNYoHRLLbCZr/eWMEyK8vvDyAkAcoZ2hsb7He9/2NrKv8E2qGSYwlI29hEmj9xf326+eWloArJteXn5dBof/YLyNBKBCGl4/FaMHbyg76DO8Fs1h16YCSgTgi7FNgwKzuIPzGyeVDM7IhoAMUZFxh/FN6gqvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727422905; c=relaxed/simple;
	bh=Nq/GzUihNbVYzxTa7EPEL5sIN9ljkiIkLuozmHVPcAM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XEm/bQ1XUAi8EWAMrblSj1DAXUsgfSNZLWa6MogEqc/xQZduRBVEOg9iOqQ31V9KNrdB4JE4Q8vxYYrloyo7NQDgJ2axjlMYT9Ygd5DjHBc8PmTuM17jvcpF/GOWrkU9V6j3QblXsb5cFoRrhcWqHaq8iuiTU+EJoMmOGppPWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CmQb5/xE; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-6e20e4e55bbso33579327b3.0
        for <live-patching@vger.kernel.org>; Fri, 27 Sep 2024 00:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1727422903; x=1728027703; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nX65nEvrl8c2bAG4dwYO3ALnsJ3H00hLsCIdrQbSMT8=;
        b=CmQb5/xE/Mfq1tt8P5H647Tpf22z/giXmVevXn/Zs4jXh7W4cy8xSG2oLidm0Tb0rn
         2uI9lskr4ukmEQBmS+yGBB+PZWciI6b7o9kA706ajhqGuzzHMBGSGRO19ZY5KN8+IKjq
         4ck6LH8v2a2ziSG/nh5bx5gGtzICwAhAm+Wadcfgs7HhzY3lCpmKUOMVlo2yZaEMsc6C
         zhA33eFWhnYgsYoJ0aug2acJvljep94/VOLpin357D7mAMA7B+NTnct4AbyHdfLBgsJP
         o6+mrnTQbWzURIPAx4O6wlw5C61bMYuoXPyLDGt6hKLA4f3DVa9HoCjphDDIrtr9PF+N
         t86g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727422903; x=1728027703;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nX65nEvrl8c2bAG4dwYO3ALnsJ3H00hLsCIdrQbSMT8=;
        b=vv/p2GmmgAlYtOAOWcAFcZrhtkLwW/NnzrUq9c0NC7ovg1V3GyltXdkaslCW7K04Ek
         xDYK9HWkW0mixTOaHid0v2dPAvc3ELQqvRJtMusmGhaBqkW6EzLnEsrgsrkyUqElmH03
         Opb6CGnDm9dQnjWR3zmBdLeYBD3ySKw49cDNGIzdwgHIAhhWMHh7BSBFA7QBNk0+HF80
         0T4/K10dudkxShDxhogzL/oNxWgqnv6s6hgzZ7bDGiD+5toKtGXgKXMh6COel4d38U+k
         HN8FPQktBkc9PovAwmu48vPquxtZbW92VpoxmkMLs6R1HcD+uEb8Iudz1bEkuTIXO3+D
         vBiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXMIr+dXhTkF50RqiIRQZiQ7euFyvX8wOrixBWpAgYlga2yszziEE7Y9s0D6+OQwQc6MLycep4Isc8rKKxt@vger.kernel.org
X-Gm-Message-State: AOJu0YwurOkDuAVbIYMXzhQS9go0VFSFuafgGZxCvhGWPHcyZ7AwGO0E
	IpSljMq+w1a6l5sm0WfGpYzONkadY1Arsqlsw865/GlEtJ5W7NYenl/Rs0AufKze+eNUFq+ujw=
	=
X-Google-Smtp-Source: AGHT+IHv+V7TrnoRkTknrxCQf2udj+QD2JXSuqMR8tmU8ZFo0gB5BIQ6MEHE/Kyko7jUwDjudbLD/oXTFQ==
X-Received: from liuweina.c.googlers.com ([fda3:e722:ac3:cc00:99:2717:ac13:e22f])
 (user=wnliu job=sendgmr) by 2002:a05:690c:700d:b0:6db:c3b8:c4ce with SMTP id
 00721157ae682-6e24762237cmr646337b3.7.1727422902920; Fri, 27 Sep 2024
 00:41:42 -0700 (PDT)
Date: Fri, 27 Sep 2024 07:41:41 +0000
In-Reply-To: <8e02ed1a-42a9-41ab-b1b4-cb5e66bf4018@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <8e02ed1a-42a9-41ab-b1b4-cb5e66bf4018@linux.microsoft.com>
X-Mailer: git-send-email 2.46.1.824.gd892dcdcdd-goog
Message-ID: <20240927074141.71195-1-wnliu@google.com>
Subject: Re: ARM64 Livepatch based on SFrame
From: Weinan Liu <wnliu@google.com>
To: kumarpraveen@linux.microsoft.com
Cc: broonie@kernel.org, catalin.marinas@arm.com, chenzhongjin@huawei.com, 
	jamorris@linux.microsoft.com, jpoimboe@redhat.com, kpraveen.lkml@gmail.com, 
	kumarpraveen@microsoft.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, live-patching@vger.kernel.org, 
	madvenka@linux.microsoft.com, mark.rutland@arm.com, nobuta.keiya@fujitsu.com, 
	peterz@infradead.org, sjitindarsingh@gmail.com, will@kernel.org
Content-Type: text/plain; charset="UTF-8"

We from Google are working on implementing SFrame unwinder for the Linux kernel, 
And we will be happy to collaborate with others for adding arm64 livepatch support

Weinan

