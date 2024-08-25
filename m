Return-Path: <live-patching+bounces-513-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1C995E1BA
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 06:48:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6D1F61F21AD1
	for <lists+live-patching@lfdr.de>; Sun, 25 Aug 2024 04:48:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD0A29408;
	Sun, 25 Aug 2024 04:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JfLgYVTu"
X-Original-To: live-patching@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB8D22071;
	Sun, 25 Aug 2024 04:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724561289; cv=none; b=becvi2m2lGNzvzYgK6dTn88nAtdAimYzge1kQ++mCGFUJMkJ05KjB76KJODghuOiw3jSVpb2GXDZkJJrs6vXOZu2O4thpdNyly7fHIDr+LD+UwSgdRfeaC65zJLkEmPpYFCq18V5PulndyO6CHLOCRf7zxXmA33jj3+Af03OLB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724561289; c=relaxed/simple;
	bh=jv3RtTXQetFXkntQm9SEZkI2RZkMtINoMc+BCprPGLI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=smbuyWARR1BA6SzN4Zy0ChM2Io3ZsB2yNqmk6ZK7xYLftRVJ1nX8FpeeprO4nOybmiqj3y+yFr/V0UfHLnG/VBSgv4iFIuv6362NIIHvAi0jHMCIpnRyh3tYmfKciZUQ4ZxhkoTfI0MJyARIlZS5x3p94rB4IvjoRqv/4aWNfGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JfLgYVTu; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=EUZtqUdunSdkCqMcIW2pbOoLaZdckWxvlh7OZtU9YiQ=; b=JfLgYVTub94Irjeqcjy2ZnhhQA
	VOHnzmU3xvw7P8/I5CNy0x5JqJa93dH6nkFSsJX28tZPtFxJ6yJTZ2T22IU7Nmn4YhageLUO5HgRd
	aVzHd+m87WeJHM/49sGa16iaiDr1i5tm8nmt0a3+EHgwY11cvgfkAVOJi0umZhMDSSSWU0Il6HVsG
	ACJvd+whNFG3ze+VtiZHIdcoAHZ4JsTCV4pR5HOgNCYVqKAfemGuTAcUd9+GBd6haVLlL0SbErhl6
	Z4OlS0elUlwh9xI34NWXGBA9KNlrzyqwIXl2sK4lnGB0hlvAY2366P09itALXBfi2tWJOsQZRPBnF
	vG17qtFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1si5AZ-00000003bJH-1FY3;
	Sun, 25 Aug 2024 04:48:03 +0000
Date: Sat, 24 Aug 2024 21:48:03 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Wardenjohn <zhangwarden@gmail.com>
Cc: jpoimboe@kernel.org, mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] Introduce klp_ops into klp_func structure
Message-ID: <Zsq3g4HE4LWcHHDb@infradead.org>
References: <20240822030159.96035-1-zhangwarden@gmail.com>
 <20240822030159.96035-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240822030159.96035-2-zhangwarden@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Aug 22, 2024 at 11:01:58AM +0800, Wardenjohn wrote:
> 1. Move klp_ops into klp_func structure.
> Rewrite the logic of klp_find_ops and
> other logic to get klp_ops of a function.
> 
> 2. Move definition of struct klp_ops into
> include/linux/livepatch.h

Why?


