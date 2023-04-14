Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93F026E1F11
	for <lists+live-patching@lfdr.de>; Fri, 14 Apr 2023 11:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbjDNJLo (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Apr 2023 05:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjDNJLn (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Apr 2023 05:11:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43C6181
        for <live-patching@vger.kernel.org>; Fri, 14 Apr 2023 02:11:42 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 198A01FD93;
        Fri, 14 Apr 2023 09:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1681463501; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LrpNnCj+m+LRZWUPm2VTsoQNKvAB0BmdodW0QbQ0aGk=;
        b=SFzO+GhTtgD6jveslNO5zEmKY1SOzp8Um1OUNQUQHKA/AIjDurpmj9/WCra+D/2RYUG/mO
        ww/JD4DCN8qUeFS/Vr1layWNFCXwugiKktioKE/6U3RwQHk74wW3+Js6oAommyHs+MNnuf
        tNG60R5gDxPNeaNtNDJhRLVV0r4qs20=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1681463501;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LrpNnCj+m+LRZWUPm2VTsoQNKvAB0BmdodW0QbQ0aGk=;
        b=YtbLnj2mdkw8t8zabQsGUya/mXKmq6EIisX6Kqv6w63Imm/pFmU2X0iUpkU6XQgcR8/VHs
        02kMuYDqIrdpskBA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id AFFEB2C143;
        Fri, 14 Apr 2023 09:11:40 +0000 (UTC)
Date:   Fri, 14 Apr 2023 11:11:40 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@kernel.org, jikos@kernel.org, pmladek@suse.com,
        joe.lawrence@redhat.com, nstange@suse.de, mpdesouza@suse.de,
        mark.rutland@arm.com, broonie@kernel.org
cc:     live-patching@vger.kernel.org
Subject: Re: Live Patching Microconference at Linux Plumbers
In-Reply-To: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
Message-ID: <alpine.LSU.2.21.2304141110460.4426@pobox.suse.cz>
References: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

> You can find the proposal below. Comments are welcome. The list of topics 
> is open, so feel free to add more. I tried to add key people to discuss 
> the topics, but the list is not exhaustive. I would like to submit the 
> proposal soonish even though the deadline is on 1 June. I assume that we 
> can update the topics later. My plan is to also organize a proper Call for 
> Topics after the submission and advertise it also on LKML.

submitted now.

> Last but not least it would be nice to have a co-runner of the show. Josh, 
> Joe, any volunteer? :)

Joe is the co-runner. Thank you!

Miroslav
