Return-Path: <live-patching+bounces-729-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C80ED998C56
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 17:51:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3951C23AFB
	for <lists+live-patching@lfdr.de>; Thu, 10 Oct 2024 15:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 466A71CCB54;
	Thu, 10 Oct 2024 15:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qi3Zb5U5"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716118FDAB;
	Thu, 10 Oct 2024 15:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728575479; cv=none; b=IWs9G5bArrJzkNhHOotfRuOrDybZTFO25ZW0GKGvc/YWlUNFzMKqIkThCiPYKETaTjIIDeKYiGHZ3nJE4RIQCLvLJPanc2i3EVyDcEzt20SHkqEPLfqhbNOK+NgU8Ii5bft7LHa7sq2a58ggWFE2Ue/FrOm3g3KuZ6a4qDk/e+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728575479; c=relaxed/simple;
	bh=ttQ8cFNdImZtFW4BofuTsTI+cZD6lZfjDSK+dfOaST0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GzGqhMruAGAzmjy93Sd2CLh1V6yNoKflwMN9OjTTDINI6NARaqXqL3eMD8jcTvBsCQd6DnmFJ0EUlsIWdcIsSER537Y/FhuvixijZUQpGLyZu5gPRTZT1HkBtI02Dj+E1wAGr2TCXoGV14JNTAyHAjLyaQ+mnR1GgD0L4JunBRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qi3Zb5U5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD99C4CECF;
	Thu, 10 Oct 2024 15:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728575478;
	bh=ttQ8cFNdImZtFW4BofuTsTI+cZD6lZfjDSK+dfOaST0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qi3Zb5U5qfghxlLeNd/zwKWDyQ+ZvBqVnrTIS8QOK3LrpOVG0BOKiTFL2Eio6c54J
	 ZECKIGiXX2eOKWAnc0z8KATEEejcpYlMENUJN473EaK1n6F1uR/r5wA+cQAZRPP8PN
	 OlDkBkau6Oqj5IJBEwxS3A+W2IYfI4MDcnTbgTNg+AdFj+nAw8Byka5jy5U1ppP4kP
	 hJGN/eiE58cPo1Bve20TDyCerIM83tT+NWkFlf/A/64biRFZbNQbiiP7lshU2uim8G
	 Vo4n1OYUmzLTbYek7s8dQJc3J3iMcMsx/6BcnnOu/rVFgbFlTO7JQKRZ4l8hQug+KA
	 6DvKc10djWgNA==
Date: Thu, 10 Oct 2024 08:51:16 -0700
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: zhang warden <zhangwarden@gmail.com>
Cc: Marcos Paulo de Souza <mpdesouza@suse.com>,
	Miroslav Benes <mbenes@suse.cz>, Jiri Kosina <jikos@kernel.org>,
	Petr Mladek <pmladek@suse.com>,
	Joe Lawrence <joe.lawrence@redhat.com>,
	live-patching@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] selftests: livepatch: add test cases of stack_order
 sysfs interface
Message-ID: <20241010155116.cuata6eg3lb7usvd@treble.attlocal.net>
References: <20241008075203.36235-1-zhangwarden@gmail.com>
 <20241008075203.36235-2-zhangwarden@gmail.com>
 <0d554ea7bd3f672d80a2566f9cbe15a151372c32.camel@suse.com>
 <A35F0A92-8901-470C-8CDF-85DE89D2597F@gmail.com>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A35F0A92-8901-470C-8CDF-85DE89D2597F@gmail.com>

On Thu, Oct 10, 2024 at 11:11:56PM +0800, zhang warden wrote:
> > IIUC, you only need to test the stack order by loading LP modules. In
> > this case you could use our currently existing LP testing module for
> > that, right? That's what we currently do when testing different sysfs
> > attributes.
> > 
> 
> Yes, in fact, those three module I submitted is reuse the existing LP
> testing module of 'test_klp_livepatch'. Because I found some module
> in test module set "klp_replace" attribute true. If a module set this
> attribute true, it will disable the previous module. 
> 
> What's more, testing this 'stack_order' attribute need more than one
> module, hoping to change the same function. And breaking the '.replace'
> value of existing module may not be a good way. So I decided to copy 
> more test module with '.replace=false' and this module is changing 
> the same function.

Maybe add a replace=[true|false] module parameter.

-- 
Josh

