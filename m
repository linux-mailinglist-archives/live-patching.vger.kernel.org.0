Return-Path: <live-patching+bounces-48-lists+live-patching=lfdr.de@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BAD4E7FD397
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 11:09:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 70D66282C4A
	for <lists+live-patching@lfdr.de>; Wed, 29 Nov 2023 10:08:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8768C199A2;
	Wed, 29 Nov 2023 10:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="2hmSJZi2";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="YAhU6Phs"
X-Original-To: live-patching@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F961AE;
	Wed, 29 Nov 2023 02:08:52 -0800 (PST)
Received: from relay2.suse.de (unknown [149.44.160.134])
	by smtp-out2.suse.de (Postfix) with ESMTP id 4224D1F8B9;
	Wed, 29 Nov 2023 10:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1701252528; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J7JfkCPCOox035EJ8rHsuyLyZw+nbqdhxo9abnfk9bU=;
	b=2hmSJZi2fN90o4KRs7/4rSIhKpjeAHDMx4NZnd/YUzHRAY75MWQtg7vc9tpIkqCgYK47vx
	1T4teG1V6QHdkAwzhEoqgSxYCRWrOu8eowQUte+VjGfXEbT02KIU2qFQ4f2RD9zqavl7VL
	0iWQz+BsNOimqhYlrZ/Lx4ARL8U/+4Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1701252528;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J7JfkCPCOox035EJ8rHsuyLyZw+nbqdhxo9abnfk9bU=;
	b=YAhU6PhsnycWzJEdUnMlLYKVSrz/FjudowBcx1LIumBDTHTs8cyPpDqM/ZjIU3WgRGIHtE
	WhFQbmYa6PcfVEDA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by relay2.suse.de (Postfix) with ESMTPS id EC9B32C161;
	Wed, 29 Nov 2023 10:08:45 +0000 (UTC)
Date: Wed, 29 Nov 2023 11:08:46 +0100 (CET)
From: Miroslav Benes <mbenes@suse.cz>
To: Randy Dunlap <rdunlap@infradead.org>
cc: Matthew Wilcox <willy@infradead.org>, attreyee-muk <tintinm2017@gmail.com>, 
    jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com, 
    joe.lawrence@redhat.com, corbet@lwn.net, live-patching@vger.kernel.org, 
    linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Took care of some grammatical mistakes
In-Reply-To: <0e7941d8-d9b2-4253-9ad5-0f7806e45e2e@infradead.org>
Message-ID: <alpine.LSU.2.21.2311291105430.12159@pobox.suse.cz>
References: <20231127155758.33070-1-tintinm2017@gmail.com> <202dbdf5-1adf-4ffa-a50d-0424967286ba@infradead.org> <ZWX1ZB5p5Vhz7WD2@casper.infradead.org> <0e7941d8-d9b2-4253-9ad5-0f7806e45e2e@infradead.org>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
Precedence: bulk
X-Mailing-List: live-patching@vger.kernel.org
List-Id: <live-patching.vger.kernel.org>
List-Subscribe: <mailto:live-patching+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:live-patching+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spamd-Bar: ++++++++++++++
X-Spam-Score: 14.49
X-Rspamd-Server: rspamd1
Authentication-Results: smtp-out2.suse.de;
	dkim=none;
	spf=pass (smtp-out2.suse.de: domain of mbenes@suse.cz designates 149.44.160.134 as permitted sender) smtp.mailfrom=mbenes@suse.cz;
	dmarc=none
X-Rspamd-Queue-Id: 4224D1F8B9
X-Spamd-Result: default: False [14.49 / 50.00];
	 RDNS_NONE(1.00)[];
	 SPAMHAUS_XBL(0.00)[149.44.160.134:from];
	 TO_DN_SOME(0.00)[];
	 RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
	 R_SPF_ALLOW(-0.20)[+ip4:149.44.0.0/16];
	 HFILTER_HELO_IP_A(1.00)[relay2.suse.de];
	 HFILTER_HELO_NORES_A_OR_MX(0.30)[relay2.suse.de];
	 R_RATELIMIT(0.00)[rip(RLa6h5sh378tcam5q78u)];
	 MID_RHS_MATCH_FROMTLD(0.00)[];
	 MX_GOOD(-0.01)[];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 RCVD_NO_TLS_LAST(0.10)[];
	 FROM_EQ_ENVFROM(0.00)[];
	 R_DKIM_NA(2.20)[];
	 MIME_TRACE(0.00)[0:+];
	 RDNS_DNSFAIL(0.00)[];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 FREEMAIL_ENVRCPT(0.00)[gmail.com];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 DMARC_NA(1.20)[suse.cz];
	 NEURAL_SPAM_SHORT(3.00)[1.000];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_SPAM_LONG(3.50)[1.000];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[jakubmarian.com:url,ludwig.guru:url];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FREEMAIL_CC(0.00)[infradead.org,gmail.com,kernel.org,suse.com,redhat.com,lwn.net,vger.kernel.org];
	 RCVD_COUNT_TWO(0.00)[2];
	 HFILTER_HOSTNAME_UNKNOWN(2.50)[]

On Tue, 28 Nov 2023, Randy Dunlap wrote:

> 
> 
> On 11/28/23 06:12, Matthew Wilcox wrote:
> > On Mon, Nov 27, 2023 at 11:41:31AM -0800, Randy Dunlap wrote:
> >> Hi,
> >>
> >> On 11/27/23 07:57, attreyee-muk wrote:
> >>> Respected Maintainers, 
> >>>
> >>> I have made some grammatical changes in the livepatch.rst file where I
> >>> felt that the sentence would have sounded more correct and would have become easy for
> >>> beginners to understand by reading. 
> >>> Requesting review of my proposed changes from the mainatiners. 
> >>>
> >>> Thank You
> >>> Attreyee Mukherjee
> >>>
> >>> Signed-off-by: attreyee-muk <tintinm2017@gmail.com>
> >>> ---
> >>>  Documentation/livepatch/livepatch.rst | 8 ++++----
> >>>  1 file changed, 4 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/Documentation/livepatch/livepatch.rst b/Documentation/livepatch/livepatch.rst
> >>> index 68e3651e8af9..a2d2317b7d6b 100644
> >>> --- a/Documentation/livepatch/livepatch.rst
> >>> +++ b/Documentation/livepatch/livepatch.rst
> >>> @@ -35,11 +35,11 @@ and livepatching:
> >>>  
> >>>  All three approaches need to modify the existing code at runtime. Therefore
> >>> -they need to be aware of each other and not step over each other's toes.
> >>> +they need to be aware of each other and not step over each others' toes.
> >>
> >> I've never seen that written like that, so I disagree here. FWIW.
> > 
> > "Step over" is new to me too.  I see "step on" much more often.
> 
> Agreed.

Yes. Attreyee, please fix this instead.
 
> > As far as placement of the apostrophe,
> > https://ludwig.guru/s/step+on+each+others+toes
> > suggests either omitting the apostrophe or placing it after the s,
> > as attreyee-muk has done is most common.
> 
> Apparently you can find anything on the internet.  :)
> 
> Here's the other side:
> 
> https://jakubmarian.com/each-others-vs-each-others-in-english/

I am not a native speaker, but "step on each other's toe" sounds the best 
to me. Or perhaps even "they need to be aware of each other and not step 
on their toes" since it is then kind of implied? English is difficult :).

Miroslav

