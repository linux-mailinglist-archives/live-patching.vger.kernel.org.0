Return-Path: <live-patching+bounces-112-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5158251A5
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 11:16:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10AE51C22E4E
	for <lists+live-patching@lfdr.de>; Fri,  5 Jan 2024 10:16:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EC71250EB;
	Fri,  5 Jan 2024 10:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="giXftoIc"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A1724B50
	for <live-patching@vger.kernel.org>; Fri,  5 Jan 2024 10:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a28b1095064so165111866b.2
        for <live-patching@vger.kernel.org>; Fri, 05 Jan 2024 02:15:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1704449727; x=1705054527; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FThmF1KfLD+/NVi/KGR4P9794wquYWw371K6rJem6UQ=;
        b=giXftoIcMLSyWUhpoIS2zfcyrXESES7rW2qSctJqMV6/xS02u0c1JhX8Mt/p3fiegL
         aPzNra5/sjM/QMUtIjXC3zzjH2A97TBfnQz32plCVgZ4yTkp03oZxifVKCYlFkshZ/2g
         gWrdicn2jhBs1PQuW3uqqNXyL08OaDqbT9PL2eeYqaxu6Ftj0oUx+cs37p2HzUz2B+Mk
         2S+DPiijhIhb5b+hjPU7IvvgS1Rlp8gEKRALe4cXpY6sMXkFof7Kf6uE2qeYY5mTY2z8
         gwfYFJax1AaSCQQ5D1Oos1N9JlGxvsFX9sxU55BT+/Bf3qBOgn3fWTUD070hxxNeuCoi
         6OyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704449727; x=1705054527;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FThmF1KfLD+/NVi/KGR4P9794wquYWw371K6rJem6UQ=;
        b=DjSWDP7/kPIWvMVRhyEPZ1sIEPlZAO3rYD/wdBuceIPHesudSlKWwVUJYT5Gi4BLe1
         4hqXcsLlGw+j4rCgdZ7UF/3oNHGiVjOLXxf2iPgdNHV2yjdX1TQP8e17JU/VkPmHNdV3
         oBJDLUp8WrfCipsdKDeKziJWYIoysWLlQMZJi/wjBsPO1+rwBw9wGgN+fsFcZ7uVO70M
         052+8jPmVDTBKR0KyCum4995/BBB7lwQogww5GAXJMXIjIzkrsGXKYyzsbXo5nxqYtTH
         +LUQO5UtplBQfaeZzFpHlHI8shtj3PZhoDiNGL7v08L3lsFzYk2omUfqEJrQrtp1jpnV
         V3hQ==
X-Gm-Message-State: AOJu0YzKKEjc6/AYe39srmKT9guUKyTQa1PPyyZOgNkOGl+5DF4BK/qT
	zeIwNnV6EY0kJgWVjYOg8xa2t4vn+UqDag==
X-Google-Smtp-Source: AGHT+IEZKw+V7M2JG8/qO4TtiUpcruIIjuVv682TH6r/M2XbdTaGztDsI5pHnBY/mGOoxzYdDrPVMw==
X-Received: by 2002:a17:907:1b11:b0:a28:fde4:6fc6 with SMTP id mp17-20020a1709071b1100b00a28fde46fc6mr621121ejc.135.1704449726934;
        Fri, 05 Jan 2024 02:15:26 -0800 (PST)
Received: from alley ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id lz22-20020a170906fb1600b00a28f54aacf1sm711429ejb.185.2024.01.05.02.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jan 2024 02:15:26 -0800 (PST)
Date: Fri, 5 Jan 2024 11:15:24 +0100
From: Petr Mladek <pmladek@suse.com>
To: Lukas Hruska <lhruska@suse.cz>
Cc: Miroslav Benes <mbenes@suse.cz>, Josh Poimboeuf <jpoimboe@kernel.org>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v1 1/5] livepatch: Create and include UAPI headers
Message-ID: <ZZfWjUeHbClvlS9p@alley>
References: <20231106162513.17556-1-lhruska@suse.cz>
 <20231106162513.17556-2-lhruska@suse.cz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106162513.17556-2-lhruska@suse.cz>

On Mon 2023-11-06 17:25:09, Lukas Hruska wrote:
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> 
> Define klp prefixes in include/uapi/linux/livepatch.h, and use them for
> replacing hard-coded values in kernel/livepatch/core.c.
> 
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> Signed-off-by: Lukas Hruska <lhruska@suse.cz>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

