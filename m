Return-Path: <live-patching+bounces-1868-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB79C6B2E9
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 19:20:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AA3B04E05A7
	for <lists+live-patching@lfdr.de>; Tue, 18 Nov 2025 18:20:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B46B34B1A8;
	Tue, 18 Nov 2025 18:20:41 +0000 (UTC)
X-Original-To: live-patching@vger.kernel.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC4062DECB2;
	Tue, 18 Nov 2025 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763490041; cv=none; b=sGYMSnYJG97Z9q5X5S0xklQdgno+qe60UEV+ePtOeDSVhfQWXrWBn/0Zc7w3GLf7yrnzd6DHhKL7NRNX2W3tK+fqRyMKTQ629ZNhb4lSMdWml8KKNy+8OKe61ifTtXRAQP6ZY2i4x2dhwG5ohcpSXbAft6gehKq8l7+rPmtnPWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763490041; c=relaxed/simple;
	bh=WU7pJxxMB4yWIoeiC5OtbzY5ZJQTT3Yx5r/pAgcliK0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=peeANbMRiOKX9b2wosjyhKrapNtWR1qEbtk06EnV6oNgeltNNGRvXgyg1xxqklLqecKZHd/o5ulQfxmnQsiaN24erSP0qim9mgy+47JmSVm3XbQwJ3+uIepIkD9MrJcI6ii51PPMmM9To/IVdtEokCyGZRqwY4mMdZhwamDyrps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C44071A0104;
	Tue, 18 Nov 2025 18:20:30 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf18.hostedemail.com (Postfix) with ESMTPA id 2B1882E;
	Tue, 18 Nov 2025 18:20:27 +0000 (UTC)
Date: Tue, 18 Nov 2025 13:20:54 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Puranjay Mohan <puranjay12@gmail.com>, Dylan Hatch
 <dylanbhatch@google.com>, Song Liu <song@kernel.org>, Indu Bhagat
 <indu.bhagat@oracle.com>, Peter Zijlstra <peterz@infradead.org>, Will
 Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Jiri
 Kosina <jikos@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Weinan Liu <wnliu@google.com>, Mark Rutland <mark.rutland@arm.com>, Ian
 Rogers <irogers@google.com>, linux-toolchains@vger.kernel.org,
 linux-kernel@vger.kernel.org, live-patching@vger.kernel.org,
 joe.lawrence@redhat.com, Puranjay Mohan <puranjay@kernel.org>
Subject: Re: [PATCH v2 0/6] unwind, arm64: add sframe unwinder for kernel
Message-ID: <20251118132054.24b1e90e@gandalf.local.home>
In-Reply-To: <bcxe5hhenqdodutgp7vd7b7aqn7emrlsezlu7stjjmfxgwc3gw@q3ggnid7ooyd>
References: <20250904223850.884188-1-dylanbhatch@google.com>
	<CAPhsuW5zUEeM3DAw-3OVNS9KmM2vG9B1GaR9KEKS_KFQo-VG9Q@mail.gmail.com>
	<CANk7y0hUKOVXRKoJ5Ufmg-5DGSe2F5nBH+O7tLVvLRs9Oe54uA@mail.gmail.com>
	<CADBMgpwZ32+shSa0SwO8y4G-Zw14ae-FcoWreA_ptMf08Mu9dA@mail.gmail.com>
	<nzmtsafrx5vjitgfpducjaa7kq747a3sler2vvyvfbxecutn3v@7ffl2ycnaoo2>
	<20251117184223.3c03fe92@gandalf.local.home>
	<cxxj6lzs226ost6js5vslm52bxblknjwd6llmu24h3bk742zjh@7iwwi5bafysq>
	<CANk7y0hKH6vvWf3Lyc678uvF9YWStMzO-Sj8yb3sbS4=4dxC6Q@mail.gmail.com>
	<bcxe5hhenqdodutgp7vd7b7aqn7emrlsezlu7stjjmfxgwc3gw@q3ggnid7ooyd>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 2B1882E
X-Stat-Signature: 4dg4q9e3i98613o4pzr1fujz6rhkcmq1
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18fXKEMTuE3xfSIbkHTDC3RX+YzB6Ci88k=
X-HE-Tag: 1763490027-988240
X-HE-Meta: U2FsdGVkX180p4Cmw7X12nBF4/qn5s7bImiMYQIf1CRppFI4Ws/pNWvXaouPaOGkfxEgdaJ+mI+9KX9zMNK9i95/jEDx63giR3lMPqCStG1nGWAXvF2pE/VlZ1UzgmKT98ImpBVg8DLR6+Y72g66JNsg6fMPfNtwOjpeNlQzC/fvjSGwhGJAhA7PPOsvErN+10wdD5+qEeqgMsn02aBKEAU2WMBTBrd2cXl9tO+FhKFKsLSkvZkm0As08FF5eHAulXlAjj7hCe//fu2p4U6Dikl7o4MjyS6Cht6aKBT7Uzx6qvYyAbP0PdfuX0e1oYpNG9k4W9JalJWkwIAD/ClXwnBCpl8V+guN

On Mon, 17 Nov 2025 21:18:41 -0800
Josh Poimboeuf <jpoimboe@kernel.org> wrote:

> > > To fix that, I suppose we would need some kind of dynamic ORC
> > > registration interface.  Similar to what has been discussed with
> > > sframe+JIT.  
> > 
> > I work with the BPF JITs and would be interested in exploring this further,
> > can you point me to this discussion if it happened on the list.  
> 
> Sorry, nothing specific has been discussed that I'm aware of :-)

Right, the only discussions have been at the monthly Sframe meetings about
needing to be able to handle this. But the actual implementation details
have not been figured out yet.

-- Steve

