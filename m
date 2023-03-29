Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C77996CD915
	for <lists+live-patching@lfdr.de>; Wed, 29 Mar 2023 14:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjC2MGU (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 29 Mar 2023 08:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjC2MGO (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 29 Mar 2023 08:06:14 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C8A04EEF
        for <live-patching@vger.kernel.org>; Wed, 29 Mar 2023 05:05:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7542A219D3;
        Wed, 29 Mar 2023 12:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1680091544; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=CA8WbooHwA3Lx/72ZDJgwpfVc4q2jHfKT3H4ZJwYuRQ=;
        b=VtVWm+xKCT0homtI1Ffyub5snTmrBq0MbBqNM0mvMLvCKt7OnTBdcXcTzKzQ5qAerF7Vv+
        r+dTYlXOW6hlwLa9+Q6uiUvDZKgw1GDW9oEUrmbRFCQSxr9hIUB4txzodrtGQzDCwMazvn
        rKNs0XcZhdzJG36YyuEhwW/qeAeDuDY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1680091544;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type;
        bh=CA8WbooHwA3Lx/72ZDJgwpfVc4q2jHfKT3H4ZJwYuRQ=;
        b=NTpuvXMUJTVumiGPFl6SfMOP53TeBqCvOsyFO5DSlc1Vs7Ap7zYI9kCRJeliD+k+AFZlqr
        /PfFiIvq/AdnpqAg==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 1F5942C141;
        Wed, 29 Mar 2023 12:05:44 +0000 (UTC)
Date:   Wed, 29 Mar 2023 14:05:43 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        pmladek@suse.com, joe.lawrence@redhat.com, nstange@suse.de,
        mpdesouza@suse.de, mark.rutland@arm.com, broonie@kernel.org
cc:     live-patching@vger.kernel.org
Subject: Live Patching Microconference at Linux Plumbers
Message-ID: <alpine.LSU.2.21.2303291339090.21599@pobox.suse.cz>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

Hi,

we would like to organize Live Patching Microconference at Linux Plumbers 
2023. The conference will take place in Richmond, VA, USA. 13-15 November. 
https://lpc.events/. The call for proposals has been opened so it is time 
to start the preparation on our side.

You can find the proposal below. Comments are welcome. The list of topics 
is open, so feel free to add more. I tried to add key people to discuss 
the topics, but the list is not exhaustive. I would like to submit the 
proposal soonish even though the deadline is on 1 June. I assume that we 
can update the topics later. My plan is to also organize a proper Call for 
Topics after the submission and advertise it also on LKML.

Last but not least it would be nice to have a co-runner of the show. Josh, 
Joe, any volunteer? :)

Thank you
Miroslav


Proposal
--------
The Live Patching microconference at Linux Plumbers 2023 aims to gather
stakeholders and interested parties to discuss proposed features and
outstanding issues in live patching.

Live patching is a critical tool for maintaining system uptime and
security by enabling fixes to be applied to running systems without the
need for a reboot. The development of the infrastructure is an ongoing
effort and while many problems have been resolved and features
implemented, there are still open questions, some with already submitted
patch sets, which need to be discussed.

Live Patching microconferences at the previous Linux Plumbers
conferences proved to be useful in this regard and helped us to find
final solutions or at least promising directions to push the development
forward. It includes for example a support for several architectures
(ppc64le and s390x were added after x86_64), a late module patching and
module dependencies and user space live patching.

Currently proposed topics follow. The list is open though and more will
be added during the regular Call for Topics.

  - klp-convert (as means to fix CET IBT limitations) and its 
    upstreamability
  - shadow variables, global state transition
  - kselftests and the future direction of development
  - arm64 live patching

Key people

  - Josh Poimboeuf <jpoimboe@kernel.org>
  - Jiri Kosina <jikos@kernel.org>
  - Miroslav Benes <mbenes@suse.cz>
  - Petr Mladek <pmladek@suse.com>
  - Joe Lawrence <joe.lawrence@redhat.com>
  - Nicolai Stange <nstange@suse.de>
  - Marcos Paulo de Souza <mpdesouza@suse.de>
  - Mark Rutland <mark.rutland@arm.com>
  - Mark Brown <broonie@kernel.org>

We encourage all attendees to actively participate in the
microconference by sharing their ideas, experiences, and insights.

