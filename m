Return-Path: <live-patching+bounces-300-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F6BF8D588F
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 04:17:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE2CC2826B6
	for <lists+live-patching@lfdr.de>; Fri, 31 May 2024 02:17:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A40BF20DC4;
	Fri, 31 May 2024 02:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TqIFkSET"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434984C6D;
	Fri, 31 May 2024 02:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717121827; cv=none; b=KY8Rrrdo3ZNqithj9yxsd5tsMkjwBvyENm3h7BTBX0mAjbOVEZUHOp7tQlB7PSiMxmsc/zCVdWAAhU5PvqnRd8eSvh6UJOilw5wMnQK4dmXH8T0Ukt/ctPcNihggxcJwPDmlFkmwVWqtrBif694LVhVG17IwQgr8NePYBolHPJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717121827; c=relaxed/simple;
	bh=ChFmsqTuhqCWj9Q0CuDq9Et2eZr78DFDG1R2WzdOpxM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GslapNbfGQqb+IvHTM11rFcD770loFEZsMwW4ld9Dc7/LJJ/45KMP0ffHrqyZ/+6g4xVWfdkQS6qvStVdQ6IqpinZPl1ZDt3Ix38rOdepPl7kX/1gV2SOY/fsGs1pP/gKj8s6i0SMBQXJ5UKSuee7Q/hjmOORZ0Zb+S26HZg9xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TqIFkSET; arc=none smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-5b9817a135aso847119eaf.0;
        Thu, 30 May 2024 19:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1717121825; x=1717726625; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ChFmsqTuhqCWj9Q0CuDq9Et2eZr78DFDG1R2WzdOpxM=;
        b=TqIFkSETR9+ZWUkCnZrs8BSlKVMoyqnhUbvTSzgIILIWwr3NOuB8XrlvPTzaAgRG9C
         lrWZP7XAg2A9PthqFzDku/eATS0v33GGG5yf64edw+hKbnvTGIv5mw6k4RUyULQYL9U8
         ziirKPMF5Cs6nuM0MQQ12YLDYuMIpD3ZMBOTAfXpcw78PIT9KzJDX3o1fsgECZIztJYl
         gFDQB2mEUEBAOywOq5+x0j3pk31gnH7wWIKRiXAnaGF4AMzPSSZmQwNGArsRHjchXj5K
         tGXChVFoKXX+bUZq1WvDsdbyikP2sF4Z9NCjffpQHU3ILTH5AANjgQb9j3SYUTxcTl1s
         M07Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717121825; x=1717726625;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ChFmsqTuhqCWj9Q0CuDq9Et2eZr78DFDG1R2WzdOpxM=;
        b=wPr3z38u6SOdOHCtLthPesm/TKSH4dwYrPxyW3hE6XwRXJH0rMpzIxqz+fAiXskPfk
         ec3BdfBtW+IOE9EsiYtmemyg9AXM9jVuIrD07S8OeBceIjPpyFhVGs930mdTI9S4w9XD
         sJn8Ry0RQxwVSUy6lzPMgBi8xNfU+Hfnvf9jXJyGoqfa2fvkj3twmteQ3H8T6jPcZoZP
         msAnPlkodqzVYav3Kh3g3ZzBWf1U7XDlOC60SKS0SNdZ2UJwzKpi/XpooSoQNKBPy5O8
         c/6vRS/F0aXHaKf7RbqiaKvTSerR2iFh41/Iav6oyX3CNA3BUM2qLXZMzSX2NHfpadGg
         1GDA==
X-Forwarded-Encrypted: i=1; AJvYcCXAReCo0mE9vNE9aN0Ou5Ecm82ILtYGbARfFhc88EYv88CB3k94JwI570irGzvK+guHDBKQmAKby1ppwJsT0vM9LiyE8i4hf80DeE31KGeLfspFeuoFWKgEBh8ghyPCHl0YXOJssBoFEi+1aQ==
X-Gm-Message-State: AOJu0Yzvnb0VyHdMeyqTk0vHtGSije1pIP0pJc0XiuXO1nbsgB/5R9Ab
	93n3N0RlZfP9YI+lyovcnogRFLdzL66Ibwmm3hnXdnrfDRwDNUUr
X-Google-Smtp-Source: AGHT+IFWDmPVOfAz9M39oJcVLgklrgfEF71/eAZOJCXmybnDydmg1DxI6zz9lMLjRV4/a8gX34adLg==
X-Received: by 2002:a05:6358:6f05:b0:198:e35d:6800 with SMTP id e5c5f4694b2df-19b489cd7d7mr92627655d.3.1717121825093;
        Thu, 30 May 2024 19:17:05 -0700 (PDT)
Received: from smtpclient.apple ([198.11.178.15])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c359564fcfsm373594a12.75.2024.05.30.19.17.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2024 19:17:04 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.500.171.1.1\))
Subject: Re: [PATCH] livepatch: introduce klp_func called interface
From: zhang warden <zhangwarden@gmail.com>
In-Reply-To: <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
Date: Fri, 31 May 2024 10:16:46 +0800
Cc: Miroslav Benes <mbenes@suse.cz>,
 Josh Poimboeuf <jpoimboe@kernel.org>,
 Jiri Kosina <jikos@kernel.org>,
 Joe Lawrence <joe.lawrence@redhat.com>,
 live-patching@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2551BBD9-735E-4D1E-B1AE-F5A3F0C38815@gmail.com>
References: <20240520005826.17281-1-zhangwarden@gmail.com>
 <alpine.LSU.2.21.2405200845130.11413@pobox.suse.cz>
 <BBD2A553-6D44-4CD5-94DD-D8B2D5536F94@gmail.com>
 <alpine.LSU.2.21.2405210823590.4805@pobox.suse.cz>
 <ZkxVlIPj9VZ9NJC4@pathway.suse.cz>
To: Petr Mladek <pmladek@suse.com>
X-Mailer: Apple Mail (2.3774.500.171.1.1)


Hi Bros,

How about my patch? I do think it is a viable feature to show the state =
of the patched function. If we add an unlikely branch test before we set =
the 'called' state, once this function is called, there maybe no =
negative effect to the performance.

Please give me some advice.

Regards,
Wardenjohn=

