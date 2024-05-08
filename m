Return-Path: <live-patching+bounces-252-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 393BF8BF567
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 07:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5A5081C229E6
	for <lists+live-patching@lfdr.de>; Wed,  8 May 2024 05:05:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FFC6134B0;
	Wed,  8 May 2024 05:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DPpTPbaw"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E458F68;
	Wed,  8 May 2024 05:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715144717; cv=none; b=MVLxbAtC3HIe0agSOcIRX2jd+e0KWBRShN2o4cvF5qGemXCgpL2YobQoXxrcpYEMTBHD0wCuUXT/z8e9QJtlhfptPWjFllrDPWoOrx5YmIyzDaXnCiT1VLP1mZS411ogro+aX28VUFBYc8SOVtk157aY8IlNOtVxZHSTSylEEgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715144717; c=relaxed/simple;
	bh=bMy6Krj7CEX4LaG/ia6ktN2lfW2cpoEzgMDuzSkWyE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYOZfdUmTOO99MpVqAO2780VrxPy5P8ooJbLa32m1Ap51lL5g+3rSfcgV9iivKVY28WTN/OJdtVh3Aq7JWZmTENYdqM4mbUgAVkTLoHPZk5EkzYX4DlSB1jL3LpguQhphaDZdSiW6qm+ijeq9oWhA2VaAhmVZTnWmfsKmAbKRvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DPpTPbaw; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33CD3C113CC;
	Wed,  8 May 2024 05:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715144716;
	bh=bMy6Krj7CEX4LaG/ia6ktN2lfW2cpoEzgMDuzSkWyE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DPpTPbawSlLCxpZddreHAkLPtN+GTHIZZbx+eKRIIGNg+TWf+D5U7mwhUpFwWbUN8
	 QPv9t0jesjLLLS7G5mhtIY4qC3LAJ9q325LJ2LmGLwJcWTStK0fXDgCm9HJB7Hxx6s
	 V4HogZdM2O2RpowBny8Obq95HE+lKEBUEGs5ELAYIP1tw96RiZHskWdLdxq1ZVF4CD
	 K9tYoPjPUakDwhq9ju8tYIEDzlKJp2sD1Muh9R/POLXGH7LRbtsBfMJKn+kz7AqjBC
	 q6JKbRdD/YfEU+0CkK3SFkiI+ZbIFQcUKg7+rtS0TOwZRO+fFEyDZf37xLZmipk8GZ
	 QqTlZRzZvi7jQ==
Date: Tue, 7 May 2024 22:05:14 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhangwarden@gmail.com
Cc: mbenes@suse.cz, jikos@kernel.org, pmladek@suse.com,
	joe.lawrence@redhat.com, live-patching@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] livepatch: Rename KLP_* to KLP_TRANSITION_*
Message-ID: <20240508050514.gb6jrd3ri4xagtvj@treble>
References: <20240507050111.38195-1-zhangwarden@gmail.com>
 <20240507050111.38195-2-zhangwarden@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240507050111.38195-2-zhangwarden@gmail.com>

On Tue, May 07, 2024 at 01:01:11PM +0800, zhangwarden@gmail.com wrote:
> From: Wardenjohn <zhangwarden@gmail.com>
> 
> The original macros of KLP_* is about the state of the transition.
> Rename macros of KLP_* to KLP_TRANSITION_* to fix the confusing
> description of klp transition state.
> 
> Signed-off-by: Wardenjohn <zhangwarden@gmail.com>

Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>

-- 
Josh

