Return-Path: <live-patching+bounces-2-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CA90B7A8DA9
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 22:16:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D69D11C20BE6
	for <lists+live-patching@lfdr.de>; Wed, 20 Sep 2023 20:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75BB741233;
	Wed, 20 Sep 2023 20:15:44 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0275F4121C
	for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 20:15:42 +0000 (UTC)
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C623DCC
	for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 13:15:39 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-76ef80a503fso10086185a.1
        for <live-patching@vger.kernel.org>; Wed, 20 Sep 2023 13:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695240939; x=1695845739; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KjiggUyQYaXdrX5h9h6CEmaZNsBN7wNveaVEjl3faww=;
        b=gzcneh+E/b39WZFZXupKfrJrFkgyKJK9LLcVsVadvicyjNcx3Oqe/r5Ae8yqn1Sqf6
         aUlogDFXfVuZkuF13TiSBw9uZGqlk69veUO4L6dG75tVnFfk7zpzik86CadtK7IbzHO5
         LWUP49N5s65Z48Fyi6pNFIOpU0lXEfIaWhOxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695240939; x=1695845739;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KjiggUyQYaXdrX5h9h6CEmaZNsBN7wNveaVEjl3faww=;
        b=aPP2H65IyapIda5iYaTXKfqw8NfX3LXXhJ8am1LrYAv9pjpwVUQrTmGTvj6fplsuyk
         Ix9eK29wiiVR81st88eU9gfM4lpCl1ezF044o8Yc0MevyuGRpaOPgmwYELa529ypTVrv
         eKDchkvPnPDCDxzLoZwvEiuhveRMyQruKvzUA7ntfh8DNH/vS/4drwNnVmaFiUwK/VfQ
         D97goS7HZBIKlIq1DhcpeKdvalWYolCmaBRC5W0IChE1oUGwUyJ7tI4QUejT35k/V1dX
         YEndoL4XVtdhSiYSvpPE7QWqjZyBX4JIYa1is5pIZIZrGUyPktm4Xcr2i0S53a1wwUh6
         BZtA==
X-Gm-Message-State: AOJu0YwthptatXItlp+NmnxDqlOHkRj0QbELed5tApGoMWBduOBhMOxz
	jdeYrxN9L9BTJfXyFshJgDlMdA==
X-Google-Smtp-Source: AGHT+IGzk01VxcNRtiMCm3IRpOiOofgFrIbB2ochwvXCEJnvd8LLC832yOxk2yPa78lhoBtatxrQnA==
X-Received: by 2002:a05:620a:2943:b0:772:6419:89ab with SMTP id n3-20020a05620a294300b00772641989abmr4647613qkp.55.1695240938672;
        Wed, 20 Sep 2023 13:15:38 -0700 (PDT)
Received: from meerkat.local ([209.226.106.110])
        by smtp.gmail.com with ESMTPSA id t2-20020a05620a034200b0076ce061f44dsm5369qkm.25.2023.09.20.13.15.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 13:15:38 -0700 (PDT)
Date: Wed, 20 Sep 2023 16:15:29 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: dwarves@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-rt-users@vger.kernel.org, linux-rtc@vger.kernel.org, linux-trace-devel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org
Subject: Re: This list is being migrated to new infrastructure
Message-ID: <20230920-ligament-cortex-6344a0@meerkat>
References: <20230920-uncouple-grime-729f33@meerkat>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230920-uncouple-grime-729f33@meerkat>
X-Spam-Status: No, score=2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	RCVD_IN_DNSWL_BLOCKED,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
	SUSPICIOUS_RECIPS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Sep 20, 2023 at 03:52:05PM -0400, Konstantin Ryabitsev wrote:
> Hello, all:
> 
> This list is being migrated to the new vger infrastructure. This should be a
> fully transparent process and you don't need to change anything about how you
> participate with the list or how you receive mail.
> 
> There will be a brief 20-minute delay with archives on lore.kernel.org. I will
> follow up once the archive migration has been completed.

This work is now completed. I will monitor the performance to make
sure that the new infrastructure is still successfully coping with the
email traffic.

If you notice any problems, please report them to helpdesk at kernel.org.

-K

