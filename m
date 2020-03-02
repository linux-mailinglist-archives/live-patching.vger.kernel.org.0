Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB2D176090
	for <lists+live-patching@lfdr.de>; Mon,  2 Mar 2020 17:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbgCBQ6U convert rfc822-to-8bit (ORCPT
        <rfc822;lists+live-patching@lfdr.de>); Mon, 2 Mar 2020 11:58:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:47200 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgCBQ6U (ORCPT <rfc822;live-patching@vger.kernel.org>);
        Mon, 2 Mar 2020 11:58:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D1E5CAE3C;
        Mon,  2 Mar 2020 16:58:18 +0000 (UTC)
From:   Nicolai Stange <nstange@suse.de>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     Nicolai Stange <nstange@suse.de>, jpoimboe@redhat.com,
        live-patching@vger.kernel.org
Subject: Re: [help] Confusion on livepatch's per-task consistency model
References: <315f87a7-eb40-67a7-4ab9-4b384fde752a@linux.alibaba.com>
        <87mu8z6o1r.fsf@suse.de>
        <cd038cf3-4629-6602-1d23-9f0cabb45083@linux.alibaba.com>
Date:   Mon, 02 Mar 2020 17:58:17 +0100
In-Reply-To: <cd038cf3-4629-6602-1d23-9f0cabb45083@linux.alibaba.com>
        (jefflexu@linux.alibaba.com's message of "Mon, 2 Mar 2020 21:19:21
        +0800")
Message-ID: <87mu8yvgly.fsf@suse.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: live-patching-owner@vger.kernel.org
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

JeffleXu <jefflexu@linux.alibaba.com> writes:

> So as far as I understand, for all kinds of (data/locking) semantic
> changes, it's the responsibility of the patch writer to detect the
> semantic changes, and usually it can only be analyzed case by
> case. Right?

Exactly :)

Nicolai

-- 
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
(HRB 36809, AG Nürnberg), GF: Felix Imendörffer
