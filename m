Return-Path: <live-patching+bounces-46-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F38DB7FBC6D
	for <lists+live-patching@lfdr.de>; Tue, 28 Nov 2023 15:13:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 321A21C20D1C
	for <lists+live-patching@lfdr.de>; Tue, 28 Nov 2023 14:13:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE7B85AB91;
	Tue, 28 Nov 2023 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="k1ccndGc"
X-Original-To: live-patching@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BBAD199A;
	Tue, 28 Nov 2023 06:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=dDWm9CUcqa7qH41B7Whj98vA6MVRIJzvGrAmMTqWiVM=; b=k1ccndGcLX6gUrYTrCsxIBOFGl
	MkeYFx0GPSGokeSazUCoUuLws3DX7En3ARF0MB7KShSYyfXYvZDxNFJmI4gEury/xhXb+jdoh0mAI
	Aak9JTHFBKhCHIXnnENMLukO7iYICrx0lKZfV/lbtK1DkNhHM9QM+/xR3iKdGdm9qFqwRwWywrtfk
	wnA9oT/9M75jgLWJH62gKjBSTg4H3XtnO8ehVjKrU8BJNNPccLobTDH5os1FU4rw88AhHtmO1vUqr
	ONBqILc6/puYX3jZJQ9rE29ZKFUtXW+/kZ2AWwaks/K/vbaxupdyeq2khx6QiGTDSUrw5qmGlbW2r
	QRHicwBw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r7ypZ-00CQUv-0M; Tue, 28 Nov 2023 14:12:53 +0000
Date: Tue, 28 Nov 2023 14:12:52 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: attreyee-muk <tintinm2017@gmail.com>, jpoimboe@kernel.org,
	jikos@kernel.org, mbenes@suse.cz, pmladek@suse.com,
	joe.lawrence@redhat.com, corbet@lwn.net,
	live-patching@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Took care of some grammatical mistakes
Message-ID: <ZWX1ZB5p5Vhz7WD2@casper.infradead.org>
References: <20231127155758.33070-1-tintinm2017@gmail.com>
 <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org>
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org>

On Mon, Nov 27, 2023 at 11:41:31AM -0800, Randy Dunlap wrote:
> Hi,
> 
> On 11/27/23 07:57, attreyee-muk wrote:
> > Respected Maintainers, 
> > 
> > I have made some grammatical changes in the livepatch.rst file where I
> > felt that the sentence would have sounded more correct and would have become easy for
> > beginners to understand by reading. 
> > Requesting review of my proposed changes from the mainatiners. 
> > 
> > Thank You
> > Attreyee Mukherjee
> > 
> > Signed-off-by: attreyee-muk <tintinm2017@gmail.com>
> > ---
> >  Documentation/livepatch/livepatch.rst | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
> > index 68e3651e8af9..a2d2317b7d6b 100644
> > --- a/Documentation/livepatch/livepatch.rst
> > +++ b/Documentation/livepatch/livepatch.rst
> > @@ -35,11 +35,11 @@ and livepatching:
> >  
> >  All three approaches need to modify the existing code at runtime. Therefore
> > -they need to be aware of each other and not step over each other's toes.
> > +they need to be aware of each other and not step over each others' toes.
> 
> I've never seen that written like that, so I disagree here. FWIW.

"Step over" is new to me too.  I see "step on" much more often.
As far as placement of the apostrophe,
https://ludwig.guru/s/step+on+each+others+toes
suggests either omitting the apostrophe or placing it after the s,
as attreyee-muk has done is most common.


