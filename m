Return-Path: <live-patching+bounces-1142-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 232C8A2D916
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 22:58:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20B913A2526
	for <lists+live-patching@lfdr.de>; Sat,  8 Feb 2025 21:57:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9615F1F3BBE;
	Sat,  8 Feb 2025 21:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b="b0zrDUD8"
X-Original-To: live-patching@vger.kernel.org
Received: from server-598995.kolorio.com (server-598995.kolorio.com [162.241.152.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48B341F3BBA
	for <live-patching@vger.kernel.org>; Sat,  8 Feb 2025 21:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.241.152.247
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739051883; cv=none; b=pAbRd3zJdaO2RoyIQTcW9MnomB1Guv4vKU0OCIuwD487ZEXZpZ/ofpucUxXE+dYeeq9QBXN0RsKkZhTU6pCoJEEY7rGd6sFumD7nbS+346CIbPJgvAlIObPbPqJVb++zgGhdj62enJvroWCt93sk5GiwRrpiJhV1ToDkODcf0o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739051883; c=relaxed/simple;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type; b=qESQQNYDMta5gnt4MuuXsjNvJPiJu5iTrBRqLBmpOizF8utIQPb3JSc59UIvkKc+rNmCznZSpQbkggiTvbqB1SyLfyUGg/uBU9z1cEOPBKgvcvvhPu6mMRuxFalvIZH/7JyRmopLHuVcgF0c7yiar4GJYEVBYhyoSFv3pz3AU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz; spf=pass smtp.mailfrom=truemaisha.co.tz; dkim=pass (2048-bit key) header.d=truemaisha.co.tz header.i=@truemaisha.co.tz header.b=b0zrDUD8; arc=none smtp.client-ip=162.241.152.247
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=truemaisha.co.tz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=truemaisha.co.tz
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=truemaisha.co.tz; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:To:From:Reply-To:Sender:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gl4+7vNxgV9+JzZtw7EthQ6aGDgi0WVn3wQV/lnKiyo=; b=b0zrDUD82j6sIxl1j2eIDjvtiq
	Fpu6/aZfxBbJ5oZYv8sgFlmLcaIbRQsSj3zLXbt3+F94faK0jCq6F8ReKq5gV6S8jWwE5O7L4ogDW
	4py6++MZtTVvvkMrsnbiYaqUgWPolTr6CBTs95J6F2IM26tmf0ukyt7WJ9p/bwyHRp3Jqk/HAlIEz
	axEDTxOOw0yErxZGHn1LcqDs8kvjrK0CGXTaf+MSo3JuDEMx45BJfO8J0yyKZZ/3Wq7JhkcUR0UhM
	lOe1mQZqdbtXfwIuTOgyl/5X9MtFB188KNqZEa5Tz3rqlOIkrkssY9p1SCoEPPsCxX3b1LD7Ub7fA
	avoy+fwA==;
Received: from [74.208.124.33] (port=59320 helo=truemaisha.co.tz)
	by server-598995.kolorio.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96.2)
	(envelope-from <chrispinerick@truemaisha.co.tz>)
	id 1tgspq-0004yC-1r
	for live-patching@vger.kernel.org;
	Sat, 08 Feb 2025 15:57:59 -0600
Reply-To: dsong@aa4financialservice.com
From: David Song <chrispinerick@truemaisha.co.tz>
To: live-patching@vger.kernel.org
Subject: Re: The business loan- 
Date: 08 Feb 2025 21:58:00 +0000
Message-ID: <20250208210541.508922300BEE33B7@truemaisha.co.tz>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server-598995.kolorio.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - truemaisha.co.tz
X-Get-Message-Sender-Via: server-598995.kolorio.com: authenticated_id: chrispinerick@truemaisha.co.tz
X-Authenticated-Sender: server-598995.kolorio.com: chrispinerick@truemaisha.co.tz
X-Source: 
X-Source-Args: 
X-Source-Dir: 

Hello,

My name is David Song, at AA4 FS, we are a consultancy and
brokerage Firm specializing in Growth Financial Loan and joint
partnership venture. We specialize in investments in all Private
and public sectors in a broad range of areas within our Financial
Investment Services.

 We are experts in financial and operational management, due
diligence and capital planning in all markets and industries. Our
Investors wish to invest in any viable Project presented by your
Management after reviews on your Business Project Presentation
Plan.

 We look forward to your Swift response. We also offer commission
to consultants and brokers for any partnership referrals.

 Regards,
David Song
Senior Broker

AA4 Financial Services
13 Wonersh Way, Cheam,
Sutton, Surrey, SM2 7LX
Email: dsong@aa4financialservice.com


