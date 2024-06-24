Return-Path: <live-patching+bounces-362-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF5F914F19
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 15:49:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8119CB20D09
	for <lists+live-patching@lfdr.de>; Mon, 24 Jun 2024 13:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3C313E40E;
	Mon, 24 Jun 2024 13:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="NOTrgWCN"
X-Original-To: live-patching@vger.kernel.org
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67AE13DB83
	for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 13:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719236964; cv=none; b=jZV1Auv8nQhe4S9YgiNFPpLkHdBSDOPNXheCe3rndVg+8VNpDF24JmxX14BEy1BXVX4xkIYBWPVyrQAf9HgJ0bLdQNyrq7AZBY4vm0R1px0GQhi4UqiBq3nM8/tBcxVEa6d0YOzrRzlcBfq1w6CiW7NXNYBB3tvOPv/fv4Fg9v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719236964; c=relaxed/simple;
	bh=YHa52LWQyl2DP2fkvDfkR/uuChpbDiwlTv9t0HnbYP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q49pUbhkNUnoKby1Gz+wnJ5P9/s62RyZ76N2TQzESPVuZlN229ri4pYFfk7cVQEADvPzcd3hIZuEtrm+ydjl98DYBhyj781OT9sDOrEI7yICebm6owPnn/TnppOkmU8LQIImQSVo7VgUldD/3mwf3C0ddRff5mCxsFDWlYMIQ1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=NOTrgWCN; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebe785b234so47373161fa.1
        for <live-patching@vger.kernel.org>; Mon, 24 Jun 2024 06:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1719236961; x=1719841761; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PMMAROdIG6hM2WNbcQA7vJuMLGh9/PzNMbMS4TG8IfI=;
        b=NOTrgWCNpYYEN7XDEV4p9bhuNIF735HvhwcPyl/ddoU8Kk/bXojQN0FsqW/qo7lznz
         Dp+CNsapMvujAIC98r4YI+183gnxq9UeUZH6YTX8359rydz1VkgBID8wfJvc5yu94sR6
         IiwYJw+3Rvb+dJqXtAfh/55+Dcj7vgY5RB9IRR1iITSXEX7FrNMrL2RsW4pT7/x6sE/y
         CZ4O27/5I9RGf8vOrZSuC9o5hVljQrKqbV4v0wcgXl5kOs0UDJzul2kdNjSiFfgWh9oq
         of4HtcPIo7hu0kLiEI060t1P3cON6IYYswBWySf8BfeUYN1fIbfJvlx7Z0UeFkhKfvmI
         TS2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719236961; x=1719841761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PMMAROdIG6hM2WNbcQA7vJuMLGh9/PzNMbMS4TG8IfI=;
        b=k0wndD6+LE8iJdpk+qM3NemboUltcpQrE4n7mpWaUYBxSwJRwObfnZMcDta0giowJw
         b04HmM4Kt9qlSRy4+GNhDlr9H2ovpoyYlfh7PQy6KJQkEQ8cvQB5XbI8Xn2MCwVmn8uk
         P0ZW29zKqH8n2nsVHCmN84HI8r55hSwfOvoA0WEM8egQld63NLgOsSgBPV78A/pD636e
         Nk9agqUNvBtxsqw8/Bojbc8DWyKAt91ybMHRc/R+rxnHeEgzGRmtHb5ITySCtK9sNTKn
         vWYRTadiZ9axKPqgu/TdgptAMt77Dk5ndrbI2KMR1mSMLxBdmHFY2OEXA7TLLC9c5K3m
         tLMg==
X-Forwarded-Encrypted: i=1; AJvYcCX/t740JRCcQJCw1OsRK0igu1nu+DEHwLOZ5R/3Ks49c7+xZcBNVXh049Tqr8A89NnTE1pHrWHL+5zJUoUwaPxAfxyFNVXMM15CY7WWYQ==
X-Gm-Message-State: AOJu0YzA6ZWo29kskK0hFzqCAnYJ37qoSG2YtezCgUtXmRP4X9URf1iT
	7J0ZUMVS0WfmqffQtZRD3IEZ/1TC+M503WcXaACFqfxPA+CKefNo7sQg0zReJEI=
X-Google-Smtp-Source: AGHT+IG0DjRdzAa/onbMofKlnxgCXrarSaBMatA50P5bfcupsAvisU76v6JL4Zs6W7vpAI51yyuOng==
X-Received: by 2002:a2e:9b4d:0:b0:2ec:543f:6013 with SMTP id 38308e7fff4ca-2ec5931d86amr37036961fa.13.1719236960829;
        Mon, 24 Jun 2024 06:49:20 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.50])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c819a77fe7sm6791674a91.18.2024.06.24.06.49.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jun 2024 06:49:20 -0700 (PDT)
Date: Mon, 24 Jun 2024 15:49:12 +0200
From: Petr Mladek <pmladek@suse.com>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	Marcos Paulo de Souza <mpdesouza@suse.com>
Subject: Re: [PATCH v2 2/3] selftests/livepatch: Add selftests for "replace"
 sysfs attribute
Message-ID: <Znl5WBwlC0XQkelc@pathway.suse.cz>
References: <20240610013237.92646-1-laoar.shao@gmail.com>
 <20240610013237.92646-3-laoar.shao@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240610013237.92646-3-laoar.shao@gmail.com>

On Mon 2024-06-10 09:32:36, Yafang Shao wrote:
> Add selftests for both atomic replace and non atomic replace
> livepatches. The result is as follows,
> 
>   TEST: sysfs test ... ok
>   TEST: sysfs test object/patched ... ok
>   TEST: sysfs test replace enabled ... ok
>   TEST: sysfs test replace disabled ... ok
> 
> Suggested-by: Marcos Paulo de Souza <mpdesouza@suse.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>

Reviewed-by: Petr Mladek <pmladek@suse.com>

Best Regards,
Petr

